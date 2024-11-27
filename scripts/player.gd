extends CharacterBody2D

@onready var player = preload("res://scenes/player.tscn")
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var melee = $meleehitbox
@onready var weapon = find_child("Weapon")
@onready var camera = $PlayerCamera

var camera_left_padding = 300

var starting_point: float
var camera_point = null
var notmoving = true
var horizontal_direction = null
var weapon_equip = false
var previous_position: float
var isdead = Global.player_isdead

func _ready() -> void:
	$meleehitbox/CollisionShape2D.disabled = true
	weapon.texture = null
	previous_position = global_position.x
	starting_point = global_position.x
	camera_point = $PlayerCamera.position
	
func _process(delta: float) -> void:
	respawn()
	
func _physics_process(delta: float) -> void:
	if (position.x - camera_left_padding) > camera.limit_left:
		camera.limit_left = position.x - camera_left_padding
		
	if not isdead:
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
	if event.is_action_pressed("attack") and notmoving and not isdead and not weapon_equip:
		ap.play("attack")
		await ap.animation_finished
		$meleehitbox/CollisionShape2D.disabled = true
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
	ap.play("damaged")
	await ap.animation_finished
	notmoving = true
	$AnimationPlayer.stop()
	ap.play("idle")
	player_health()
	
func  player_health():
	if Global.player_health <= 0:
		isdead = true
		weapon.texture = null
		ap.play("death")
		await ap.animation_finished
		Global.player_isdead = true
		Global.set_score_record()
		
func respawn():
	if Global.player_respawn:
		
		Global.player_reset()
		weapon_equip = false
		
		# Reset position and physics state
		position.x = starting_point
		velocity = Vector2.ZERO  # Clear velocity to ensure no lingering motion
		$HitBox.disabled = false
		previous_position = starting_point
		# Reset camera
		camera.limit_left = position.x - camera_left_padding
		camera.position = Vector2(position.x, camera.position.y)  # Align camera horizontally
		
		# Reset character state
		isdead = false
		Global.player_isdead = false
		ap.play("idle")  # Reset animation to idle
		notmoving = true  # Ensure the character state is ready for movement
		
func _on_meleehitbox_body_entered(body: Node2D) -> void:
		if body.has_method("melee_hit"):
			body.melee_hit()


func _on_powerup_duration_timeout() -> void:
	Global.normal()
	$PowerupDuration.stop()
