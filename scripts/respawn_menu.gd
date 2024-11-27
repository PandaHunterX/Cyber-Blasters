extends Control

@onready var score = $PanelContainer/MarginContainer/VBoxContainer/Score
@onready var distance = $PanelContainer/MarginContainer/VBoxContainer/Distance
@onready var highest_score = $PanelContainer/MarginContainer/VBoxContainer/Highest
@onready var longest_distance = $PanelContainer/MarginContainer/VBoxContainer/Longest

func _process(delta: float) -> void:
	if Global.player_isdead:
		visible = Global.player_isdead
		get_tree().paused = Global.player_isdead
		score.text = "SCORE: " + str(Global.score)
		distance.text = "DISTANCE: " + Global.current_distance_traveled
		highest_score.text = "HIGHEST SCORE: " + str(Global.highest_score)
		longest_distance.text = "LONGEST DISTANCE: " + Global.longest_distance

func _on_respawn_pressed() -> void:
	Global.player_isdead = false
	Global.player_respawn = true
	visible = Global.player_isdead
	get_tree().paused = Global.player_isdead
	
func _on_quit_pressed() -> void:
	get_tree().quit()
