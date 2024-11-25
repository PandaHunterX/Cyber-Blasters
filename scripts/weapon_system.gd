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
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("melee") and can_change:
		$Weapon.texture = null
		Global.melee_equip = true
		Global.pistol_equip = false
		Global.smg_equip = false
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = false
		can_shoot = false
	elif event.is_action_pressed("pistol") and can_change:
		$Weapon.texture = Global.pistol
		Global.melee_equip = false
		Global.pistol_equip = true
		Global.smg_equip = false
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = false
		$WeaponCooldown.wait_time = 0.8 / Global.fire_rate_buff
		can_shoot = true
	elif event.is_action_pressed("smg") and can_change:
		$Weapon.texture = Global.smg
		$WeaponCooldown.wait_time = 0.2 / Global.fire_rate_buff
		Global.melee_equip = false
		Global.pistol_equip = false
		Global.smg_equip = true
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = false
		can_shoot = true
	elif  event.is_action_pressed("laser_rifle") and can_change:
		$Weapon.texture = Global.laser_rifle
		$WeaponCooldown.wait_time = 1.6 / Global.fire_rate_buff
		Global.melee_equip = false
		Global.pistol_equip = false
		Global.smg_equip = false
		Global.laser_rifle_equip = true
		Global.grenad_launcher_equip = false
		can_shoot = true
	elif event.is_action_pressed("grenade_launcher") and can_change:
		$Weapon.texture = Global.grenade_launcher
		$WeaponCooldown.wait_time = 2 / Global.fire_rate_buff
		Global.melee_equip = false
		Global.pistol_equip = false
		Global.smg_equip = false
		Global.laser_rifle_equip = false
		Global.grenad_launcher_equip = true
		can_shoot = true
		
func basic_fire():
	if can_shoot and is_shooting and ((Global.pistol_equip and Global.pistol_bullets >= 1) or (Global.smg_equip and Global.smg_bullets >= 1)):
		var bul = bullet.instantiate()
		add_child(bul)
		$WeaponCooldown.start()
		can_shoot = false
		if Global.pistol_equip:
			Global.pistol_bullets -= 1
		elif Global.smg_equip:
			Global.smg_bullets -= 1
		
func laser_fire():
	if can_shoot and is_shooting and Global.laser_rifle_equip and Global.laser_bullets >= 1:
		var laserbul = laserbullet.instantiate()
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
