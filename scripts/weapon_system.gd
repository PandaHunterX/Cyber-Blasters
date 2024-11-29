extends Node2D

@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var laserbullet = preload("res://scenes/laser.tscn")
@onready var grenadebullet = preload("res://scenes/explosion.tscn")

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
		Global.melee_equip = true
		Global.pistol_equip = false
		Global.smg_equip = false
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = false
		can_shoot = false
		
func _unhandled_input(event: InputEvent) -> void:
	if not can_change:
		pass
	elif event.is_action_pressed("melee") and can_change:
		$Weapon.texture = null
		Global.melee_equip = true
		Global.pistol_equip = false
		Global.smg_equip = false
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = false
		can_shoot = false
	elif event.is_action_pressed("pistol") and can_change and Global.pistol_unlock:
		$Weapon.texture = Global.pistol
		$WeaponCooldown.wait_time = Global.pistol_fire_rate
		Global.melee_equip = false
		Global.pistol_equip = true
		Global.smg_equip = false
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = false
		can_shoot = true
	elif event.is_action_pressed("smg") and can_change and Global.smg_unlock:
		$Weapon.texture = Global.smg
		$WeaponCooldown.wait_time = Global.smg_fire_rate
		Global.melee_equip = false
		Global.pistol_equip = false
		Global.smg_equip = true
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = false
		can_shoot = true
	elif  event.is_action_pressed("laser_rifle") and can_change and Global.laser_rifle_unlock:
		$Weapon.texture = Global.laser_rifle
		$WeaponCooldown.wait_time = Global.laser_fire_rate
		Global.melee_equip = false
		Global.pistol_equip = false
		Global.smg_equip = false
		Global.laser_rifle_equip = true
		Global.grenad_launcher_equip = false
		can_shoot = true
	elif event.is_action_pressed("grenade_launcher") and can_change and Global.grenade_launcher_unlock:
		$Weapon.texture = Global.grenade_launcher
		$WeaponCooldown.wait_time = Global.explosive_fire_rate
		Global.melee_equip = false
		Global.pistol_equip = false
		Global.smg_equip = false
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = true
		can_shoot = true
		
func basic_fire():
	if can_shoot and is_shooting and ((Global.pistol_equip and Global.pistol_bullets >= 1) or (Global.smg_equip and Global.smg_bullets >= 1)):
		var bul = bullet.instantiate()
		$WeaponCooldown.start()
		can_shoot = false
		if Global.pistol_equip:
			bul.position = $Pistol.position
			Global.pistol_bullets -= 1
			add_child(bul)
		elif Global.smg_equip:
			bul.position = $Rifle.position
			Global.smg_bullets -= 1
			add_child(bul)
		
func laser_fire():
	if can_shoot and is_shooting and Global.laser_rifle_equip and Global.laser_bullets >= 1:
		var laserbul = laserbullet.instantiate()
		laserbul.position = $Rifle.position
		add_child(laserbul)
		$WeaponCooldown.start()
		can_shoot = false
		Global.laser_bullets -= 1

func grenade_fire():
	if can_shoot and is_shooting and Global.grenad_launcher_equip and Global.explosive_bullets >= 1:
		var grenadebul = grenadebullet.instantiate()
		add_child(grenadebul)
		$WeaponCooldown.start()
		can_shoot = false
		Global.explosive_bullets -= 1
		
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
