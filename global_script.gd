extends Node

#Player System
var max_player_health = 100
var player_health = 100
var player_speed = 300
var player_isdead = false
var player_respawn = false
var powerup_refill = 0


#Scoring System
var score = 0
var highest_score = 0
var distance_traveled: float = 0.0
var current_distance_traveled = ""
var longest_distance_num = 0
var longest_distance = ""


func distance_calculation(player_position: float, previous_position: float, delta: float) -> float:
	var distance = abs(player_position - previous_position) * delta     # Calculate the horizontal distance and normalize by delta
	distance_traveled += distance
	return player_position

func distance():
	if not player_isdead:
		if distance_traveled >= 1000:
			var kilometers = distance_traveled / 1000
			current_distance_traveled = str(snapped(kilometers,0.01)) + "km"
		else:
			current_distance_traveled = str(round(distance_traveled)) + "m"

func set_score_record():
	if score > highest_score:
		highest_score = score
	if distance_traveled > longest_distance_num:
		longest_distance_num = distance_traveled
		longest_distance = current_distance_traveled
		
func player_reset():
	score = 0
	distance_traveled = 0.0
	current_distance_traveled = "0m"
	player_health = max_player_health
	powerup_refill = 0
	
#RNG System
var rng = RandomNumberGenerator.new()

var easy_spawn_min = 1
var easy_spawn_max = 2

var easy_sec_min = 5
var easy_sec_max = 7

#Difficulty System

var weak_enemy_level = 0

func increase_weak_level():
	weak_enemy_level += 1
	if weak_enemy_level <= 4:
		easy_spawn_min +=1
		easy_spawn_max += 1
		easy_sec_min -= 0.3
		easy_sec_max -= 0.3
	else:
		pass

#Weapon System
const melee = preload("res://assets/weapons/fist.png")
const pistol = preload("res://assets/weapons/pistol_full.png")
const smg = preload("res://assets/weapons/Assault rifle_full.png")
const laser_rifle = preload("res://assets/weapons/AK_full.png")
const grenade_launcher = preload("res://assets/weapons/Shootgun_full.png")

var pistol_unlock = false
var smg_unlock = false
var laser_rifle_unlock = false
var grenade_launcher_unlock = false

var pistol_bullets = 0
var smg_bullets = 0
var laser_bullets = 0
var explosive_bullets = 0

var pistol_limit = 30
var smg_limit = 120
var laser_limit = 12
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
	var drop_rate = rng.randi_range(1, 100) # Generate a random number between 1 and 100 for weighted probabilities
	if pistol_bullets < pistol_limit and drop_rate <= 25 and pistol_unlock: # 25% chance
		pistol_bullets += 10
	elif smg_bullets < smg_limit and drop_rate > 25 and drop_rate <= 40 and smg_unlock: # 15% chance
		smg_bullets += 30
	elif laser_bullets < laser_limit and drop_rate > 40 and drop_rate <= 50 and laser_rifle_unlock: # 7% chance
		laser_bullets += 2
	elif explosive_bullets < explosive_limit and drop_rate > 50 and drop_rate <= 54 and grenade_launcher_unlock: # 1% chance
		explosive_bullets += 1
	
	ammo_limit()
	
#Powerup System:
var speed_buff = 1
var damage_buff = 1
var fire_rate_buff = 1.0
var power_activate = false

func powerup():
	speed_buff = 2
	damage_buff = 2
	fire_rate_buff += 1.0
	power_activate = true
	powerup_refill = 0
	if player_health < max_player_health  * 0.8:
		player_health += max_player_health * 0.2
	else:
		player_health = max_player_health

var pistol_fire_rate = 0.8 / fire_rate_buff
var smg_fire_rate = 0.2 / fire_rate_buff
var laser_fire_rate = 1.6 / fire_rate_buff
var explosive_fire_rate = 2 / fire_rate_buff

func normal():
	speed_buff = 1
	damage_buff = 1
	fire_rate_buff = 1
	power_activate = false
