extends Node

#Player System
var player_health = 100
var player_speed = 300
var score = 0
var powerup_refill = 100

#RNG System

var rng = RandomNumberGenerator.new()

#Weapon System
const melee = preload("res://assets/weapons/fist.png")
const pistol = preload("res://assets/weapons/pistol_full.png")
const smg = preload("res://assets/weapons/Assault rifle_full.png")
const laser_rifle = preload("res://assets/weapons/AK_full.png")
const grenade_launcher = preload("res://assets/weapons/Shootgun_full.png")

var pistol_bullets = 0
var smg_bullets = 0
var laser_bullets = 0
var explosive_bullets = 0

var pistol_limit = 60
var smg_limit = 240
var laser_limit = 30
var explosive_limit = 5

var melee_equip = true
var pistol_equip = false
var smg_equip = false
var laser_rifle_equip = false
var grenad_launcher_equip = false

func ammo_limit():
	if pistol_bullets > pistol_limit:
		pistol_bullets = pistol_limit
	if smg_bullets > smg_limit:
		smg_bullets = smg_limit
	if laser_bullets > laser_limit:
		laser_bullets = laser_limit
	if explosive_bullets > explosive_limit:
		explosive_bullets = explosive_limit

func add_ammo():
	if pistol_bullets < pistol_limit:
		pistol_bullets += 10
	if smg_bullets < smg_limit:
		smg_bullets += 30
	if laser_bullets < laser_limit:
		laser_bullets += 2
	if explosive_bullets < explosive_limit:
		explosive_bullets += 1
	ammo_limit()
	
#Powerup System:
var speed_buff = 1
var damage_buff = 1
var fire_rate_buff = 1
var power_activate = false

func powerup():
	speed_buff = 2
	damage_buff = 2
	fire_rate_buff += 1
	power_activate = true
	powerup_refill = 0

func normal():
	speed_buff = 1
	damage_buff = 1
	fire_rate_buff = 1
	power_activate = false
