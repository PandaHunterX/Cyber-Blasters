extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var melee = $meleehitbox
@onready var weapon = find_child("Weapon")

var notmoving = true
var is_hit = false
var health = 1000
var speed = 300
var horizontal_direction = null
var isdead = false
var weapon_equip = false

func _ready() -> void:
	$meleehitbox/CollisionShape2D.disabled = true
	$HealthBar.value = health
	weapon.texture = null
		
func _physics_process(delta: float) -> void:
	if not isdead:
		var horizontal_direction = Input.get_axis("left", "right")
		velocity.x = speed * horizontal_direction
		var isLeft = velocity.x < 0
		sprite.flip_h = isLeft
		weapon.flip_h = isLeft
		move_and_slide()
		update_animations(horizontal_direction)
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and notmoving and not isdead and not weapon_equip:
		ap.play("attack")
		$AnimationCooldown.start()
	elif event.is_action_pressed("pistol"):
		weapon_equip = true
	elif event.is_action_pressed("melee"):
		weapon_equip = false
		
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
	print(health)
	ap.play("damaged")
	$AnimationCooldown.start()
	player_health()
	
func  player_health():
	if health <= 0:
		ap.play("death")
		isdead = true
		weapon.texture = null

func _on_animation_cooldown_timeout() -> void:
	update_animations(horizontal_direction)
	$AnimationCooldown.stop() 
