extends Control

# Node references
@onready var title: Label = $"PanelContainer/MarginContainer/VBoxContainer/Title"
@onready var paragraph: Label = $"PanelContainer/MarginContainer/VBoxContainer/Paragraph"
@onready var next: Button = $"PanelContainer/Next"
@onready var previous: Button = $"PanelContainer/Previous"
@onready var tutorial_popup: Control = $"."
@onready var tutorial_timer: Timer = $"Tutorial Timer"
@onready var picture: TextureRect = $PanelContainer/MarginContainer/VBoxContainer/Picture

# Tutorial data
var basic_data = [
	{
		"title": "PLAYER MOVEMENTS",
		"paragraph": "Press A to move back and D to move forward",
		"image": "res://assets/tutorial/playermovements.png"
	},
	{
		"title": "PAUSE GAME",
		"paragraph": "Press ESC to pause the game",
		"image": "res://assets/tutorial/pause.png"
	},
	{
		"title": "MELEE ATTACK",
		"paragraph": "Press E to Punch",
		"image": "res://assets/tutorial/melee.png"
	},
	{
		"title": "SCORING SYSTEM",
		"paragraph": "The score will indicate the number of enemies you've killed",
		"image": "res://assets/tutorial/score.png"
	},
	{
		"title": "POWER UP SYSTEM",
		"paragraph": "After reaching 100% energy, Press Q to activate, you are immune and you dealt double damage to your enemies, this last only 5 seconds",
		"image": "res://assets/tutorial/energy.png"
	},
	{
		"title": "LEVEL UP SYSTEM",
		"paragraph": "When you die and respawn, your former body remains, after acquiring it you level up which increases your speed and health",
		"image": "res://assets/tutorial/levelup.png"
	},
]

var weapon_data = [
	{
		"title": "WEAPON SYSTEM",
		"paragraph": "When you acquire a certain score, you unlock a new weapon",
		"image": "res://assets/tutorial/weaponsystem.png"
	},
	{
		"title": "SHOOTING",
		"paragraph": "Press or Hold F to Shoot",
		"image": "res://assets/tutorial/shooting.png"
	},
	{
		"title": "CHANGING WEAPONS",
		"paragraph": "Press TAB, 1, 2, 3, or 4 to change weapons",
		"image": "res://assets/tutorial/changingweapons.png"
	},
	{
		"title": "AMMO DROP",
		"paragraph": "Each enemy type have different ammo drop rate, so use your ammo wisely",
		"image": "res://assets/tutorial/ammodrop.png"
	}
]

var enemy_data = [
	{
		"title": "STANDARD ANDROID",
		"paragraph": "Just a Regular Android, It's weakness is laser smg",
		"image": "res://assets/tutorial/standardandroid.png"
	},
	{
		"title": "FAST ANDROID",
		"paragraph": "Fast yet low damage, have strong resistance against pistol and laser smg. It's weakness is particle rifle but have 10% chance to dogdge it",
		"image": "res://assets/tutorial/fastandroid.png"
	},
	{
		"title": "MILITARY ANDROID",
		"paragraph": "Armored, immune to particle rifle, have 20% chance to survive plasma bomb, it's weakness is unkown",
		"image": "res://assets/tutorial/militaryandroid.png"
	},
]

# State variables
var current_index = 0
var current_tutorial = basic_data
var tutorial_started = false
var tutorial1_done = false
var tutorial2_done = false
var tutorial3_done = false

func _ready() -> void:
	tutorial_popup.visible = false
	previous.visible = false
	next.visible = current_tutorial.size() > 1

	# Start the first tutorial after a delay
	if Global.player_tutorial and not Global.basic_tutorial:
		tutorial_timer.wait_time = 1.5
		tutorial_timer.start()

func _process(delta: float) -> void:
	if Global.highest_score >= 500:
		tutorial2_done = true
	if Global.highest_score >= 2100:
		tutorial3_done = true
	# Trigger tutorials based on score
	if Global.player_tutorial and not tutorial2_done and  Global.score >= 500 and current_tutorial == basic_data:
		switch_tutorial(weapon_data)
	elif Global.player_tutorial and not tutorial3_done and Global.score >= 2000 and current_tutorial == weapon_data:
		switch_tutorial(enemy_data)

func _on_previous_pressed() -> void:
	if current_index > 0:
		current_index -= 1
		update_tutorial_content()

func _on_next_pressed() -> void:
	if current_index < current_tutorial.size() - 1:
		current_index += 1
		update_tutorial_content()

func _on_skip_pressed() -> void:
	Global.player_tutorial = false
	end_tutorial()

func _on_done_pressed() -> void:
	end_tutorial()
	Global.basic_tutorial = true

func _on_tutorial_timer_timeout() -> void:
	if not tutorial_started:
		tutorial_started = true
		tutorial_popup.visible = true
		get_tree().paused = true
		update_tutorial_content()
		tutorial_timer.stop()

func update_tutorial_content() -> void:
	title.text = current_tutorial[current_index]["title"]
	paragraph.text = current_tutorial[current_index]["paragraph"]
	picture.texture = load(current_tutorial[current_index]["image"])
	previous.visible = current_index > 0
	next.visible = current_index < current_tutorial.size() - 1

func end_tutorial() -> void:
	tutorial_popup.visible = false
	get_tree().paused = false

func switch_tutorial(new_tutorial: Array) -> void:
	current_tutorial = new_tutorial
	current_index = 0
	update_tutorial_content()
	tutorial_popup.visible = true
	get_tree().paused = true
