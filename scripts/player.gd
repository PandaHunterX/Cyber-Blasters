extends CharacterBody2D

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
	$HealthBar.value = health
		
func _physics_process(delta: float) -> void:
	if not isdead:
		var horizontal_direction = Input.get_axis("move_right", "move_left")
		velocity.x = 300 * horizontal_direction
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
	$HealthBar.value = health
	is_hit = true
	ap.play("damaged")
	$AnimationCooldown.start()
	player_health()
	
func  player_health():
	if health <= 0:
		ap.play("death")
		isdead = true
		

func _on_animation_cooldown_timeout() -> void:
	update_animations(horizontal_direction)
	$AnimationCooldown.stop() 
