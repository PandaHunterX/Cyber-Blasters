extends Node2D

func _ready() -> void:
	$LaserTime.start()
	
func _on_laser_body_entered(body: Node2D) -> void:
	if body.has_method("laser_hit"):
		body.laser_hit()
		


func _on_laser_time_timeout() -> void:
	queue_free()
	$LaserTime.stop()
