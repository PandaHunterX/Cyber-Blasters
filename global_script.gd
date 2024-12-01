extends Node

#Player System
var max_player_health = 100
var player_health = 100
var player_speed = 300
var player_isdead = false
var player_respawn = false
var player_damage = 1
var powerup_refill = 0

var meelee_damage = 50  * player_damage
var pistol_damage = 50 * player_damage
var smg_damage = 15 * player_damage
var laser_damage = 25 * player_damage
var grenade_damage = 500 * player_damage

#Tutorial

var player_tutorial = true
var basic_tutorial = false



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
	#Scoring Reset
	score = 0
	distance_traveled = 0.0
	current_distance_traveled = "0m"
	player_health = max_player_health
	powerup_refill = 0
	
	#Difficulty Reset
	difficulty = player_level
	
	easy_spawn_min = 1
	easy_spawn_max = 2

	easy_sec_min = 8
	easy_sec_max = 10

	fast_spawn_min = 2
	fast_spawn_max = 3

	fast_sec_min = 4
	fast_sec_max = 6

	hard_spawn_min = 1
	hard_spawn_max = 2

	hard_sec_min = 10
	hard_sec_max = 12
	
	if player_level <= 15:
		hard_enemy_health = 0
		hard_enemy_dmg = 0
	if player_level > 15:
		hard_enemy_health = 20 * (player_level - 15)
		hard_enemy_dmg = 2 * (player_level - 15)
	#Ammo Reset
	if pistol_unlock:
		pistol_bullets = round(pistol_limit * 0.25)
	if smg_unlock:
		smg_bullets = round(smg_limit * 0.25)
	if laser_rifle_unlock:
		laser_bullets = round(laser_limit * 0.25)
	if grenade_launcher_unlock:
		explosive_bullets = round(explosive_bullets * 0.25)
		
#Level up System
var player_level = 0
var player_drop_body = false

var prev_pistol_bullet = 0
var prev_smg_bullet = 0
var prev_laser_bullet = 0
var prev_grenade_bullet = 0

func level_up():
	player_level += 1
	if player_level <= 10:
		max_player_health += 20
		player_speed += 10
		player_damage += 0.1
	player_health = max_player_health
	pistol_limit += 20
	smg_limit += 60
	laser_limit += 6
	explosive_limit += 2
	pistol_bullets += prev_pistol_bullet
	smg_bullets += prev_smg_bullet
	laser_bullets += prev_laser_bullet
	explosive_bullets += prev_grenade_bullet
	prev_pistol_bullet = 0
	prev_smg_bullet = 0
	prev_laser_bullet = 0
	prev_grenade_bullet = 0
	ammo_limit()

	
#RNG System
var rng = RandomNumberGenerator.new()

var easy_spawn_min = 1
var easy_spawn_max = 2

var easy_sec_min = 7
var easy_sec_max = 9

var fast_spawn_min = 2
var fast_spawn_max = 3

var fast_sec_min = 4
var fast_sec_max = 6

var hard_spawn_min = 1
var hard_spawn_max = 2

var hard_sec_min = 10
var hard_sec_max = 12
#Difficulty System

var difficulty = 0

var hard_enemy_health = 0
var hard_enemy_dmg = 0

func difficulty_level():
	difficulty += 1
	if difficulty <= 5:
		easy_sec_min -= 0.2 * difficulty
		easy_sec_max -= 0.2 * difficulty
		if difficulty >= 3:
			easy_spawn_min += 1 * (difficulty - 2)
			easy_spawn_max += 1 * (difficulty - 2)
	elif difficulty > 5 and difficulty <= 10:
		fast_sec_min -= 0.3 * (difficulty - 5)
		fast_sec_max -= 0.3 * (difficulty - 5)
		if difficulty >= 9:
			easy_spawn_min += 1 * (difficulty - 8)
			easy_spawn_max += 1 * (difficulty - 8)
	elif difficulty > 10 and difficulty <= 15:
		hard_sec_min -= 1 * (difficulty - 10)
		hard_sec_max -= 1 * (difficulty - 10)
		if difficulty >= 14:
			easy_spawn_min += 1 * (difficulty - 13)
			easy_spawn_max += 1 * (difficulty - 13)
	else:
		hard_enemy_health += 20 + (difficulty - 15)
		hard_enemy_dmg += 2 + (difficulty - 16)

#Weapon System
const melee = preload("res://assets/weapons/fist.png")
const pistol = preload("res://assets/weapons/weapon_pistol.png")
const smg = preload("res://assets/weapons/weapon_assault_rifle.png")
const laser_rifle = preload("res://assets/weapons/weapon_laser.png")
const grenade_launcher = preload("res://assets/weapons/weapon_grenade.png")

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
var explosive_limit = 6

var melee_equip = true
var pistol_equip = false
var smg_equip = false
var laser_rifle_equip = false
var grenad_launcher_equip = false

func melee_equip_func():
	melee_equip = true
	pistol_equip = false
	smg_equip = false
	laser_rifle_equip = false
	grenad_launcher_equip = false
	
func pistol_equip_func():
	melee_equip = false
	pistol_equip = true
	smg_equip = false
	laser_rifle_equip = false
	grenad_launcher_equip = false
	
func smg_equip_func():
	melee_equip = false
	pistol_equip = false
	smg_equip = true
	laser_rifle_equip = false
	grenad_launcher_equip = false
	
func laser_equip_func():
	melee_equip = false
	pistol_equip = false
	smg_equip = false
	laser_rifle_equip = true
	grenad_launcher_equip = false
	
func grenad_equip_func():
	melee_equip = false
	pistol_equip = false
	smg_equip = false
	laser_rifle_equip = false
	grenad_launcher_equip = true
	
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
	elif laser_bullets < laser_limit and drop_rate > 40 and drop_rate <= 50 and laser_rifle_unlock: # 10% chance
		laser_bullets += 2
	elif explosive_bullets < explosive_limit and drop_rate > 50 and drop_rate <= 55 and grenade_launcher_unlock: # 5% chance
		explosive_bullets += 1
	
	ammo_limit()
	
func add_ammo_fast():
	var drop_rate = rng.randi_range(1, 100) # Generate a random number between 1 and 100 for weighted probabilities
	if pistol_bullets < pistol_limit and drop_rate <= 50 and pistol_unlock: # 50% chance
		pistol_bullets += 10
	elif smg_bullets < smg_limit and drop_rate > 40 and drop_rate <= 70 and smg_unlock: # 30% chance
		smg_bullets += 30
	elif laser_bullets < laser_limit and drop_rate > 60 and drop_rate <= 80 and laser_rifle_unlock: # 20% chance
		laser_bullets += 2
	elif explosive_bullets < explosive_limit and drop_rate > 80 and drop_rate <= 90 and grenade_launcher_unlock: # 10% chance
		explosive_bullets += 1
	
	ammo_limit()
	
func add_ammo_hard():
	var drop_rate = rng.randi_range(1, 100) # Generate a random number between 1 and 100 for weighted probabilities
	if pistol_bullets < pistol_limit and drop_rate <= 15 and pistol_unlock: # 15% chance
		pistol_bullets += 10
	elif smg_bullets < smg_limit and drop_rate > 15 and drop_rate <= 65 and smg_unlock: # 50% chance
		smg_bullets += 30
	elif laser_bullets < laser_limit and drop_rate > 65 and drop_rate <= 80 and laser_rifle_unlock: # 15% chance
		laser_bullets += 2
	elif explosive_bullets < explosive_limit and drop_rate > 80 and drop_rate <= 100 and grenade_launcher_unlock: # 20% chance
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
	power_activate = true
	powerup_refill = 0
	if player_health < max_player_health  * 0.9:
		player_health += max_player_health * 0.1
	else:
		player_health = max_player_health

func normal():
	speed_buff = 1
	damage_buff = 1
	fire_rate_buff = 1
	power_activate = false
