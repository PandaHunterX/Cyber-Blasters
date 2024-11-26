extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var melee = $meleehitbox
@onready var weapon = find_child("Weapon")
@onready var camera = $PlayerCamera

var camera_left_padding = 300

var notmoving = true
var is_hit = false
var horizontal_direction = null
var weapon_equip = false
var previous_position: float

func _ready() -> void:
	$meleehitbox/CollisionShape2D.disabled = true
	weapon.texture = null
	previous_position = global_position.x
	
func _physics_process(delta: float) -> void:
	if (position.x - camera_left_padding) > camera.limit_left:
		camera.limit_left = position.x - camera_left_padding
	if not Global.player_isdead:
		if not velocity.x < 0:
			previous_position = Global.distance_calculation(global_position.x, previous_position, delta) #Distance Calculatiom
		#Movement
		horizontal_direction = Input.get_axis("left", "right")
		velocity.x = (Global.player_speed * Global.speed_buff) * horizontal_direction
		var isLeft = velocity.x < 0
		sprite.flip_h = isLeft
		weapon.flip_h = isLeft
		move_and_slide()
		update_animations(horizontal_direction)
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and notmoving and not Global.player_isdead and not weapon_equip:
		ap.play("attack")
		await ap.animation_finished
		notmoving = false
	elif event.is_action_pressed("pistol") or event.is_action_pressed("smg") or event.is_action_pressed("laser_rifle") or event.is_action_pressed("grenade_launcher"):
		weapon_equip = true
	elif event.is_action_pressed("melee"):
		weapon_equip = false
	elif event.is_action_pressed("power_up") and Global.powerup_refill >= 100:
		Global.powerup()
		$PowerupDuration.start()
		
func update_animations(horizontal_direction):
	if not Global.player_isdead:
		if horizontal_direction == 0:
			if notmoving == false:
				ap.play("idle")
				notmoving = true
		else:
			if notmoving == true:
				ap.play("run")
				notmoving = false

func weak_hit():
	Global.player_health -= 5
	is_hit = true
	ap.play("damaged")
	await  ap.animation_finished
	player_health()
	is_hit = false
	update_animations(horizontal_direction)
	
func  player_health():
	if Global.player_health <= 0:
		ap.play("death")
		Global.player_isdead = true
		weapon.texture = null


func _on_meleehitbox_body_entered(body: Node2D) -> void:
		if body.has_method("melee_hit"):
			body.melee_hit()


func _on_powerup_duration_timeout() -> void:
	Global.normal()
	$PowerupDuration.stop()
