extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var melee = $meleehitbox
@onready var weapon = find_child("Weapon")

var notmoving = true
var is_hit = false
var horizontal_direction = null
var isdead = false
var weapon_equip = false

func _ready() -> void:
	$meleehitbox/CollisionShape2D.disabled = true
	weapon.texture = null
		
func _physics_process(delta: float) -> void:
	if not isdead:
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
		$AnimationCooldown.start()
		await ap.animation_finished
		notmoving = false
	elif event.is_action_pressed("pistol") or event.is_action_pressed("smg") or event.is_action_pressed("laser_rifle") or event.is_action_pressed("grenade_launcher"):
		weapon_equip = true
	elif event.is_action_pressed("melee"):
		weapon_equip = false
	elif event.is_action_pressed("power_up") and Global.powerup_refill == 100:
		Global.powerup()
		$PowerupDuration.start()
		
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
	Global.player_health -= 10
	is_hit = true
	ap.play("damaged")
	$AnimationCooldown.start()
	player_health()
	
func  player_health():
	if Global.player_health <= 0:
		ap.play("death")
		isdead = true
		weapon.texture = null

func _on_animation_cooldown_timeout() -> void:
	is_hit = false
	update_animations(horizontal_direction)
	$AnimationCooldown.stop() 


func _on_meleehitbox_body_entered(body: Node2D) -> void:
		if body.has_method("melee_hit"):
			body.melee_hit()


func _on_powerup_duration_timeout() -> void:
	Global.normal()
	$PowerupDuration.stop()
