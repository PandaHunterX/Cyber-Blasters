extends Node2D

@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var laserbullet = preload("res://scenes/laser.tscn")
@onready var grenadebullet = preload("res://scenes/explosion.tscn")

const pistol = preload("res://assets/weapons/pistol_full.png")
const smg = preload("res://assets/weapons/Assault rifle_full.png")
const laser_rifle = preload("res://assets/weapons/AK_full.png")
const grenade_launcher = preload("res://assets/weapons/Shootgun_full.png")

var can_shoot = true
var is_shooting = false
var shoot_timer = 0

var melee_equip = true
var basic_weapon_equip = false
var laser_rifle_equip = false
var grenad_launcher_equip = false


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
			is_shooting = true
			shoot_timer = 0
	if Input.is_action_just_released("fire"):
		is_shooting = false
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("melee"):
		$Weapon.texture = null
		melee_equip = true
		basic_weapon_equip = false
		laser_rifle_equip = false
		grenad_launcher_equip = false
		can_shoot = false
	elif event.is_action_pressed("pistol"):
		$Weapon.texture = pistol
		basic_weapon_equip = true
		$WeaponCooldown.wait_time = 0.8
		can_shoot = true
	elif event.is_action_pressed("smg"):
		$Weapon.texture = smg
		$WeaponCooldown.wait_time = 0.2
		basic_weapon_equip = true
		can_shoot = true
	elif  event.is_action_pressed("laser_rifle"):
		$Weapon.texture = laser_rifle
		$WeaponCooldown.wait_time = 1.5
		melee_equip = false
		basic_weapon_equip = false
		laser_rifle_equip = true
		grenad_launcher_equip = false
		can_shoot = true
	elif event.is_action_pressed("grenade_launcher"):
		$Weapon.texture = grenade_launcher
		$WeaponCooldown.wait_time = 2
		melee_equip = false
		basic_weapon_equip = false
		laser_rifle_equip = false
		grenad_launcher_equip = true
		can_shoot = true
	elif event.is_action_pressed("pistol") or event.is_action_pressed("smg"):
		melee_equip = false
		basic_weapon_equip = false
		laser_rifle_equip = false
		grenad_launcher_equip = false
		
func basic_fire():
	if can_shoot and is_shooting and basic_weapon_equip:
		var bul = bullet.instantiate()
		add_child(bul)
		$WeaponCooldown.start()
		can_shoot = false
		
func laser_fire():
	if can_shoot and is_shooting and laser_rifle_equip:
		var laserbul = laserbullet.instantiate()
		add_child(laserbul)
		$WeaponCooldown.start()
		can_shoot = false

func grenade_fire():
	if can_shoot and is_shooting and grenad_launcher_equip:
		var grenadebul = grenadebullet.instantiate()
		add_child(grenadebul)
		$WeaponCooldown.start()
		can_shoot = false
		
func _on_weapon_cooldown_timeout() -> void:
	can_shoot = true
