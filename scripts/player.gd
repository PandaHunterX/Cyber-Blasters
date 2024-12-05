extends CharacterBody2D

@onready var player = preload("res://scenes/player.tscn")
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var melee = $meleehitbox
@onready var weapon = find_child("Weapon")
@onready var camera = $PlayerCamera
@onready var player_hit: AudioStreamPlayer2D = $"Player Hit"

const camera_left_padding = 500

var starting_point: float
var camera_point = null
var idle = true
var can_attack = true
var is_hit = false
var horizontal_direction = null
var weapon_equip = false
var previous_position: float
var isdead = Global.player_isdead

const MC_WALK = preload("res://assets/main character/mc_walk.png")
const MC_WALK_PISTOL = preload("res://assets/main character/mc_walk_pistol.png")
const MC_WALK_RIFLE = preload("res://assets/main character/mc_walk_rifle.png")

@onready var punch_sound: AudioStreamPlayer2D = $"Punch Sound"
@onready var player_death: AudioStreamPlayer2D = $"Player Death"
@onready var power_up_sound: AudioStreamPlayer2D = $"Power Up Sound"
@onready var power_up_ready: AudioStreamPlayer2D = $"Power Up Ready"


func _ready() -> void:
	$meleehitbox/CollisionShape2D.disabled = true
	weapon.texture = null
	previous_position = global_position.x
	starting_point = global_position.x
	camera_point = $PlayerCamera.position
	
func _process(delta: float) -> void:
	respawn()
	if Global.pistol_equip or Global.smg_equip  or Global.laser_rifle_equip  or Global.grenad_launcher_equip:
		weapon_equip = true
	if Global.melee_equip:
		weapon_equip = false
	if Global.powerup_refill == 100:
		power_up_ready.play()
		
func _physics_process(delta: float) -> void:
	if (position.x - camera_left_padding) > camera.limit_left:
		camera.limit_left = position.x - camera_left_padding
		
	if not isdead:
		if not velocity.x < 0:
			previous_position = Global.distance_calculation(global_position.x, previous_position, delta) #Distance Calculatiom
		
		#Movement
		horizontal_direction = Input.get_axis("left", "right")
		velocity.x = (Global.player_speed * Global.speed_buff) * horizontal_direction
		move_and_slide()
		update_animations(horizontal_direction)
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not isdead and not weapon_equip and can_attack:
		punch_sound.play()
		ap.play("attack")
		idle = false
		can_attack = false
		await ap.animation_finished
		can_attack = true
		$meleehitbox/CollisionShape2D.disabled = true
		idle = true
	elif event.is_action_pressed("power_up") and Global.powerup_refill >= 100:
		power_up_sound.play()
		Global.powerup()
		$PowerupDuration.start()
		
func update_animations(horizontal_direction):
	if not Global.player_isdead and idle and not is_hit:
		if horizontal_direction == 0:
			can_attack = true
			if Global.pistol_equip:
				ap.play("idle_pistol")
			if Global.smg_equip or Global.laser_rifle_equip or Global.grenad_launcher_equip:
				ap.play("idle_rifle")
			if not weapon_equip:
				ap.play("idle")
		else:
			can_attack = false
			if Global.pistol_equip:
				sprite.texture = MC_WALK_PISTOL
			elif Global.smg_equip or Global.laser_rifle_equip or Global.grenad_launcher_equip:
				sprite.texture = MC_WALK_RIFLE
			else:
				sprite.texture = MC_WALK
			
			if horizontal_direction >= 0:
				ap.play("walk")
			else:
				ap.play("walk", -1, -1.0, false)

func weak_hit():
	player_hit.play()
	is_hit = true
	if not Global.power_activate:
		Global.player_health -= 5
	ap.play("damaged")
	await ap.animation_finished
	is_hit = false
	idle = true
	$AnimationPlayer.stop()
	player_health()
	
func fast_hit():
	player_hit.play()
	is_hit = true
	if not Global.power_activate:
		Global.player_health -= 2
	ap.play("damaged")
	await ap.animation_finished
	is_hit = false
	idle = true
	$AnimationPlayer.stop()
	player_health()
	
func hard_hit():
	player_hit.play()
	is_hit = true
	if not Global.power_activate:
		Global.player_health -= 10 + Global.hard_enemy_dmg
	ap.play("damaged")
	await ap.animation_finished
	is_hit = false
	idle = true
	$AnimationPlayer.stop()
	player_health()
	
func player_health():
	if Global.player_health <= 0:
		Global.prev_pistol_bullet = Global.pistol_bullets
		Global.prev_smg_bullet = Global.smg_bullets
		Global.prev_laser_bullet = Global.laser_bullets
		Global.prev_grenade_bullet = Global.explosive_bullets
		player_death.play()
		isdead = true
		weapon.texture = null
		ap.play("death")
		await ap.animation_finished
		Global.player_isdead = true
		Global.player_drop_body = true
		Global.enemy_die = true
		Global.set_score_record()

func respawn():
	if Global.player_respawn:
		Global.player_reset()
		weapon_equip = false
		$"Enemy Respwan".start()
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
		idle = true  # Ensure the character state is ready for movement
		

func level_up():
	Global.level_up()

func _on_meleehitbox_body_entered(body: Node2D) -> void:
		if body.has_method("melee_hit"):
			body.melee_hit()

func _on_powerup_duration_timeout() -> void:
	Global.normal()
	$PowerupDuration.stop()


func _on_enemy_respwan_timeout() -> void:
	Global.enemy_die = false
