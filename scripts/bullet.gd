extends Node2D

var speed = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		position.x += speed * delta
		

func _on_bullet_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("pistol_hit") and Global.pistol_equip:
		body.pistol_hit()
		queue_free()
	elif body.has_method("smg_hit") and Global.smg_equip:
		body.smg_hit()
		queue_free()
