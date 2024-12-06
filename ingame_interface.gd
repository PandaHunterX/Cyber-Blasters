extends Control

@onready var weapon: TextureRect = $HBoxContainer/Weapon
@onready var ammo: Label = $HBoxContainer/Ammo
@onready var pistol = $ColorRect4/VBoxContainer/Pistol
@onready var smg = $ColorRect4/VBoxContainer/SMG
@onready var laser_rifle = $"ColorRect4/VBoxContainer/Laser Rifle"
@onready var grenade_launcher = $"ColorRect4/VBoxContainer/Grenade Launcher"
@onready var pistol_bullets = $"ColorRect4/VBoxContainer/Pistol/Pistol Ammo"
@onready var smg_bullets = $"ColorRect4/VBoxContainer/SMG/SMG Ammo"
@onready var laser_bullets = $"ColorRect4/VBoxContainer/Laser Rifle/Laser Ammo"
@onready var grenade_bullets = $"ColorRect4/VBoxContainer/Grenade Launcher/Grenade Ammo"

@onready var player_level: Label = $TextureRect/Player_Level


const PISTOL_ICON = preload("res://assets/ui/pistol_icon.png")
const SMG_ICON = preload("res://assets/ui/smg_icon.png")
const LASER_ICON = preload("res://assets/ui/laser_icon.png")
const GRENADE_ICON = preload("res://assets/ui/grenade_icon.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Score.text = "Score: " + str(Global.score)
	$HealthBar.value = Global.player_health
	$PowerupBar.value = Global.powerup_refill
	$Distance.text = "Distance: " + Global.current_distance_traveled
	$HealthBar/Health.text = str(Global.player_health) + "/" + str(Global.max_player_health)
	player_level.text = "Lvl: " + str(Global.player_level)
	Global.distance()
	weapons()
	weapon_ui()
	
func weapons():
	if Global.pistol_equip:
		weapon.texture = PISTOL_ICON
		ammo.text = "Ammo: " + str(Global.pistol_bullets) + "/" + str(Global.pistol_limit)
	elif Global.smg_equip:
		weapon.texture = SMG_ICON
		ammo.text = "Ammo: " + str(Global.smg_bullets) + "/" + str(Global.smg_limit)
	elif Global.laser_rifle_equip:
		weapon.texture = LASER_ICON
		ammo.text = "Ammo: " + str(Global.laser_bullets) + "/" + str(Global.laser_limit)
	elif Global.grenad_launcher_equip:
		weapon.texture = GRENADE_ICON
		ammo.text = "Ammo: " + str(Global.explosive_bullets) + "/" + str(Global.explosive_limit)
	elif  Global.melee_equip:
		weapon.texture = Global.melee
		ammo.text = "Ammo: ∞"

func weapon_ui():
	if Global.pistol_unlock:
		pistol.visible = true
	if Global.smg_unlock:
		smg.visible = true
	if Global.laser_rifle_unlock:
		laser_rifle.visible = true
	if Global.grenade_launcher_unlock:
		grenade_launcher.visible = true
	pistol_bullets.text = str(Global.pistol_bullets) + "/" + str(Global.pistol_limit)
	smg_bullets.text = str(Global.smg_bullets) + "/" + str(Global.smg_limit)
	laser_bullets.text = str(Global.laser_bullets) + "/" + str(Global.laser_limit)
	grenade_bullets.text = str(Global.explosive_bullets) + "/" + str(Global.explosive_limit)
