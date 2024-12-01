extends Node2D

@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var laserbullet = preload("res://scenes/laser.tscn")
@onready var grenadebullet = preload("res://scenes/explosion.tscn")
@onready var pistol_sound: AudioStreamPlayer2D = $"Pistol Sound"
@onready var smg_sound: AudioStreamPlayer2D = $"Smg Sound"
@onready var laser_sound: AudioStreamPlayer2D = $"Laser Sound"
@onready var grenade_launcher_sound: AudioStreamPlayer2D = $"Grenade Launcher Sound"
@onready var change_weapon_sound: AudioStreamPlayer2D = $"Change Weapon Sound"
@onready var no_ammo_sound: AudioStreamPlayer2D = $"No Ammo Sound"


var can_shoot = true
var is_shooting = false
var shoot_timer = 0
var can_change = true

func _ready() -> void:
	$WeaponCooldown.wait_time = 0.2
	
func _process(delta: float) -> void:
	weapon_unlock()
	basic_fire()
	laser_fire()
	grenade_fire()
	if Input.is_action_pressed("fire"):
		if is_shooting:
			shoot_timer += delta
			shoot_timer = 0
		else:
			can_change = false
			is_shooting = true
			shoot_timer = 0
	if Input.is_action_just_released("fire"):
		is_shooting = false
		can_change = true
		
	if Global.player_respawn:
		Global.player_respawn = false
		$Weapon.texture = null
		Global.melee_equip_func()
		can_shoot = false
		can_change = true
		
func _unhandled_input(event: InputEvent) -> void:
	if not can_change:
		pass
	elif event.is_action_pressed("melee") and can_change:
		if not Global.melee_equip:
			change_weapon_sound.play()
		$Weapon.texture = null
		Global.melee_equip_func()
		can_shoot = false
	elif event.is_action_pressed("pistol") and can_change and Global.pistol_unlock:
		if not Global.pistol_equip:
			change_weapon_sound.play()
		$Weapon.texture = Global.pistol
		$WeaponCooldown.wait_time = 0.8
		Global.pistol_equip_func()
		can_shoot = true
	elif event.is_action_pressed("smg") and can_change and Global.smg_unlock:
		if not Global.smg_equip:
			change_weapon_sound.play()
		$Weapon.texture = Global.smg
		$WeaponCooldown.wait_time = 0.1
		Global.smg_equip_func()
		can_shoot = true
	elif  event.is_action_pressed("laser_rifle") and can_change and Global.laser_rifle_unlock:
		if not Global.laser_rifle_equip:
			change_weapon_sound.play()
		$Weapon.texture = Global.laser_rifle
		$WeaponCooldown.wait_time = 1.2
		Global.laser_equip_func()
		can_shoot = true
	elif event.is_action_pressed("grenade_launcher") and can_change and Global.grenade_launcher_unlock:
		if not Global.grenad_launcher_equip:
			change_weapon_sound.play()
		$Weapon.texture = Global.grenade_launcher
		$WeaponCooldown.wait_time = 1.6
		Global.grenad_equip_func()
		can_shoot = true
		
func basic_fire():
	if can_shoot and is_shooting and ((Global.pistol_equip and Global.pistol_bullets >= 1) or (Global.smg_equip and Global.smg_bullets >= 1)):
		var bul = bullet.instantiate()
		$WeaponCooldown.start()
		can_shoot = false
		if Global.pistol_equip:
			pistol_sound.play()
			bul.position = $Pistol.position
			Global.pistol_bullets -= 1
			add_child(bul)
		elif Global.smg_equip:
			smg_sound.play()
			bul.position = $Rifle.position
			Global.smg_bullets -= 1
			add_child(bul)
	elif  ((Global.pistol_bullets <= 0 and Global.pistol_equip) or (Global.smg_bullets <= 0 and Global.smg_equip)) and is_shooting:
		no_ammo_sound.play()
		
func laser_fire():
	if can_shoot and is_shooting and Global.laser_rifle_equip and Global.laser_bullets >= 1:
		laser_sound.play()
		var laserbul = laserbullet.instantiate()
		laserbul.position = $Rifle.position
		add_child(laserbul)
		$WeaponCooldown.start()
		can_shoot = false
		Global.laser_bullets -= 1
	elif Global.laser_bullets <= 0 and Global.laser_rifle_equip and is_shooting:
		no_ammo_sound.play()
		
func grenade_fire():
	if can_shoot and is_shooting and Global.grenad_launcher_equip and Global.explosive_bullets >= 1:
		grenade_launcher_sound.play()
		var grenadebul = grenadebullet.instantiate()
		grenadebul.position = $Grenade.position
		add_child(grenadebul)
		$WeaponCooldown.start()
		can_shoot = false
		Global.explosive_bullets -= 1
	elif Global.explosive_bullets <= 0 and Global.grenad_launcher_equip and is_shooting:
		no_ammo_sound.play()
		
func _on_weapon_cooldown_timeout() -> void:
	can_shoot = true

func weapon_unlock():
	if Global.score >= 500:
		if not Global.pistol_unlock:
			Global.pistol_bullets += 10
		Global.pistol_unlock = true
	if Global.score >= 1000:
		if not Global.smg_unlock:
			Global.smg_bullets += 30
		Global.smg_unlock = true
	if Global.score >= 2000:
		if not Global.laser_rifle_unlock:
			Global.laser_bullets += 2
		Global.laser_rifle_unlock = true
	if Global.score >= 5000:
		if not Global.grenade_launcher_unlock:
			Global.explosive_bullets += 1
		Global.grenade_launcher_unlock = true
