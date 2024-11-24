extends CharacterBody2D
const JUMP_VELOCITY = -400.0
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var melee = $meleehitbox

var notmoving = true
var is_hit = false
var health = 1000
var horizontal_direction = null
var isdead = false

func _ready() -> void:
	$meleehitbox/CollisionShape2D.disabled = true
		
func _physics_process(delta: float) -> void:
	if not isdead:
		horizontal_direction = Input.get_axis("left", "right")
		velocity.x = 300 * horizontal_direction
		var isLeft = velocity.x < 0
		sprite.flip_h = isLeft
		move_and_slide()
		update_animations(horizontal_direction)
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and notmoving and not isdead:
		ap.play("attack")
		$AnimationCooldown.start()
	
func update_animations(horizontal_direction):
	if not isdead:
		if horizontal_direction == 0:
			if notmoving == false:
				ap.play("idle")
				notmoving = true
		else:
			if notmoving == true:
				ap.play("run")
				notmoving = false

func weak_hit():
	health -= 100
	is_hit = true
	print(health)
	ap.play("damaged")
	$AnimationCooldown.start()
	player_health()
	
func player_health():
	if health <= 0:
		ap.play("death")
		isdead = true
		

func _on_animation_cooldown_timeout() -> void:
	update_animations(horizontal_direction)
	$AnimationCooldown.stop() # Replace with function body.
