extends Node2D

var speed = 1500
var onhit = false

func free() -> void:
	$"Grenade Hit/GrenadeHitbox".disabled = true
	
func _physics_process(delta: float) -> void:
	if not onhit:
		position.x += speed * delta
	else :
		position.x = position.x

func _on_enemy_detection_body_entered(body: Node2D) -> void:
	if body.has_method("explosive_hit"):
		body.explosive_hit()
		onhit = true
		$AnimationPlayer.play("Explosion")
		$ExplosionTimer.start()


func _on_explosion_timer_timeout() -> void:
	queue_free()
