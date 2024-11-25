extends Node2D

var speed = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		position.x += speed * delta
		

func _on_bullet_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("bullet_hit"):
		body.bullet_hit()
		queue_free()
