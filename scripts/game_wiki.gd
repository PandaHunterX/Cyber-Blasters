extends Control

@onready var player_name: Label = $"TabContainer/Player Stats/Name"
@onready var health: Label = $"TabContainer/Player Stats/Health"
@onready var level: Label = $"TabContainer/Player Stats/Level"
@onready var speed: Label = $"TabContainer/Player Stats/Speed"
@onready var melee_dmg: Label = $"TabContainer/Player Stats/Melee Dmg"

@onready var pistol_dmg: Label = $"TabContainer/Player Stats/Pistol Dmg"
@onready var smg_dmg: Label = $"TabContainer/Player Stats/Smg Dmg"
@onready var laser_dmg: Label = $"TabContainer/Player Stats/Laser Dmg"
@onready var grenade_dmg: Label = $"TabContainer/Player Stats/Grenade Dmg"

@onready var highest_score: Label = $"TabContainer/Player Stats/Highest Score"
@onready var longest_distance: Label = $"TabContainer/Player Stats/Longest Distance"

func _ready() -> void:
	level.text = "Level: " + str(Global.player_level)
	health.text = "Health: " + str(Global.max_player_health)
	speed.text = "Speed: " + str(Global.player_speed)
	melee_dmg.text = "Melee Dmg: " + str(Global.meelee_damage)
	
	pistol_dmg.text = "Damage: " + str(Global.pistol_damage)
	smg_dmg.text = "Damage: " + str(Global.smg_damage)
	laser_dmg.text = "Damage: " + str(Global.laser_damage)
	grenade_dmg.text = "Damage: " + str(Global.grenade_damage)
 
	highest_score.text = "Highest Score: " + str(Global.highest_score)
	longest_distance.text = "Longest Distance: " + str(Global.longest_distance)

func _on_close_pressed() -> void:
	visible = false
