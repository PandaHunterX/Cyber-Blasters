extends Control




func _on_yes_pressed() -> void:
	await Global.new_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")



func _on_no_pressed() -> void:
	visible = false
