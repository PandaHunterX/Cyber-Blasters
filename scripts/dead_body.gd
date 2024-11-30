extends Node2D

@onready var level_up_sound: AudioStreamPlayer2D = $"Level up Sound"

func _ready() -> void:
		$"Dead Body Respawn".start()
		$Detection/CollisionShape2D.disabled = true
	
func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_method("level_up"):
		level_up_sound.play()
		body.level_up()
		$Detection/CollisionShape2D.disabled = true
		await level_up_sound.finished
		queue_free()


func _on_dead_body_respawn_timeout() -> void:
	$Detection/CollisionShape2D.disabled = false
	$"Dead Body Respawn".stop()
