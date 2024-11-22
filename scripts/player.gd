extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var melee = $meleehitbox

var notmoving = true
var is_hit = false
var health = 1000
		
func _physics_process(delta: float) -> void:
	var horizontal_direction = Input.get_axis("move_right", "move_left")
	velocity.x = 300 * horizontal_direction
	move_and_slide()
	update_animations(horizontal_direction)
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and notmoving:
		ap.play("attack")
	
func update_animations(horizontal_direction):
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
	player_health()
	
func  player_health():
	if health <= 0:
		ap.play("death")
		
