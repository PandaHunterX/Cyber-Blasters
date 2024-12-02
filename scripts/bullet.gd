extends Node2D

var speed = 2000

@onready var bullet: Sprite2D = $Bullet
const BULLET_NORMAL = preload("res://assets/bullets/bullet_normal.png")
const BULLET_SHORT = preload("res://assets/bullets/bullet_short.png")

func _process(delta: float) -> void:
	if Global.pistol_equip:
		bullet.texture = BULLET_NORMAL
	elif Global.smg_equip:
		bullet.texture = BULLET_SHORT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		global_position.x += speed * delta
		if position.x >= 5500:
			queue_free()

func _on_bullet_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("pistol_hit") and Global.pistol_equip:
		body.pistol_hit()
		queue_free()
	elif body.has_method("smg_hit") and Global.smg_equip:
		body.smg_hit()
		queue_free()
