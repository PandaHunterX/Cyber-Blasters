extends Node2D

var speed = 1500
var onhit = false

func _ready() -> void:
	$"Grenade Hit/GrenadeHitbox".disabled = true
	
func _physics_process(delta: float) -> void:
	if not onhit:
		position.x += speed * delta
	else :
		position.x = position.x
		$"Enemy Detection/Detection".disabled = true

func _on_enemy_detection_body_entered(body: Node2D) -> void:
	if body.has_method("explosive_hit"):
		onhit = true
		$AnimationPlayer.play("Explosion")
		$ExplosionTimer.start()

func _on_explosion_timer_timeout() -> void:
	queue_free()


func _on_grenade_hit_body_entered(body: Node2D) -> void:
	if body.has_method("explosive_hit"):
		body.explosive_hit()
