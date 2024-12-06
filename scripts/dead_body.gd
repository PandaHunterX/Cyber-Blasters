extends Node2D

@onready var level_up_sound: AudioStreamPlayer2D = $"Level up Sound"
@onready var collision_shape_2d: CollisionShape2D = $Detection/CollisionShape2D
@onready var detection: Area2D = $Detection
@onready var dead_body_respawn: Timer = $"Dead Body Respawn"
var pick_up_remaining = 3

func _ready() -> void:
	$"Dead Body Respawn".start()
	detection.monitoring = false

func game_restarted() -> void:
	dead_body_respawn.start()


func _on_detection_body_entered(body: Node2D) -> void:
	if body.has_method("level_up"):
		level_up_sound.play()
		body.level_up()
		detection.set_deferred("monitoring", false)
		pick_up_remaining -= 1
		if pick_up_remaining == 0:
			await level_up_sound.finished
			queue_free()


func _on_dead_body_respawn_timeout() -> void:
	detection.monitoring = true
	$"Dead Body Respawn".stop()
