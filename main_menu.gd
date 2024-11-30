extends Control


func _ready() -> void:
	pass # Replace with function body.




func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
	Global.player_reset()
