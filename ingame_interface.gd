extends Control

@onready var weapon = $ColorRect2/Weapon
@onready var ammo = $ColorRect2/Ammo

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ColorRect/Score.text = "Score: " + str(Global.score)
	$HealthBar.value = Global.player_health
	$PowerupBar.value = Global.powerup_refill
	distance()
	weapons()
	
func weapons():
	if Global.pistol_equip:
		weapon.texture = Global.pistol
		ammo.text = "Ammo: " + str(Global.pistol_bullets) + "/" + str(Global.pistol_limit)
	elif Global.smg_equip:
		weapon.texture = Global.smg
		ammo.text = "Ammo: " + str(Global.smg_bullets) + "/" + str(Global.smg_limit)
	elif Global.laser_rifle_equip:
		weapon.texture = Global.laser_rifle
		ammo.text = "Ammo: " + str(Global.laser_bullets) + "/" + str(Global.laser_limit)
	elif Global.grenad_launcher_equip:
		weapon.texture = Global.grenade_launcher
		ammo.text = "Ammo: " + str(Global.explosive_bullets) + "/" + str(Global.explosive_limit)
	elif  Global.melee_equip:
		weapon.texture = Global.melee
		ammo.text = "Ammo: ∞"

func distance():
	if Global.distance_traveled >= 1000:
		var kilometers = Global.distance_traveled / 1000
		$ColorRect3/Distance.text = "Distance: " + str(snapped(kilometers,0.01)) + "km"
	else:
		$ColorRect3/Distance.text = "Distance: " + str(round(Global.distance_traveled)) + "m"
