extends Node2D

var speed = 1000
var is_pistol = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		position.x += speed * delta

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pistol"):
		is_pistol = true
	elif  event.is_action_pressed("smg"):
		is_pistol = false
		

func _on_bullet_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("pistol_hit") and is_pistol:
		body.pistol_hit()
		queue_free()
	elif body.has_method("smg_hit") and not is_pistol:
		body.smg_hit()
		queue_free()
