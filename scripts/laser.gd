extends Node2D

var speed = 1500

func _physics_process(delta: float) -> void:
		position.x += speed * delta
		


func _on_laser_body_entered(body: Node2D) -> void:
	if body.has_method("laser_hit"):
		body.laser_hit()
		$LaserTime.start()


func _on_laser_time_timeout() -> void:
	queue_free()
	$LaserTime.stop()
