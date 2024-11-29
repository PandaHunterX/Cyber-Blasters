extends Node

@onready var weak_enemy = preload("res://scenes/enemy_weak.tscn")

func _ready() -> void:
	$Respawn.start()



func spawn_weak_enemy() -> void:
	var weak = weak_enemy.instantiate()
	weak.position = $Player/Path2D/PathFollow2D/Marker2D.global_position
	add_child(weak)
	


func _on_respawn_timeout() -> void:
	spawn_weak_enemy()
