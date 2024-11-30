extends Control


func _ready() -> void:
	pass # Replace with function body.




func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	Global.player_isdead = false
	Global.player_respawn = true


func _on_exit_pressed() -> void:
	get_tree().quit()
