extends Node2D


func _ready() -> void:
		$"Dead Body Respawn".start()
		$Detection/CollisionShape2D.disabled = true
	
func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_method("level_up"):
		body.level_up()
		queue_free()


func _on_dead_body_respawn_timeout() -> void:
	$Detection/CollisionShape2D.disabled = false
	$"Dead Body Respawn".stop()
