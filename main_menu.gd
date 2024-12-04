extends Control

@onready var game_wiki: Control = $"CanvasLayer/Game Wiki"
@onready var background_music: AudioStreamPlayer2D = $"Background Music"
@onready var new_game: Control = $"CanvasLayer/New Game"


func _ready() -> void:
	background_music.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	Global.player_isdead = false
	Global.player_respawn = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_stats_tutorial_pressed() -> void:
	game_wiki.visible = true


func _on_new_game_pressed() -> void:
	new_game.visible = true
