extends CharacterBody2D

@onready var target_scene = preload("res://scenes/player.tscn")
@onready var player_detection = $PlayerHit

var health = 100
var target: Node2D
var speed = 150
var is_hit = false  # Flag to check if the character is hit
var attack_ready = true
var player_detected = false

func _ready():
	# Instance the player and add it to the scene
	target = target_scene.instantiate() as Node2D
	$PlayerHit/AttackHitbox.disabled = true

func _physics_process(delta):
	if not is_hit and not player_detected:
		move_enemy()
	else:
		velocity = Vector2.ZERO 
		
func move_enemy():
	if target:  # Ensure target exists
		# Calculate horizontal direction only
		var direction_x = (target.global_position.x - global_position.x)
		direction_x = direction_x / abs(direction_x) if direction_x != 0 else 0  # Normalize direction
		velocity.x = direction_x * speed
		velocity.y = 0  # Ensure no vertical movement
		$AnimationPlayer.play("walk")
	move_and_slide()

func melee_hit():
	$PlayerHit/AttackHitbox.disabled = true
	health -= 50 * Global.damage_buff
	is_hit = true  # Set hit flag to true
	$AnimationPlayer.play("hit")
	enemy_health()
	$AttackCooldown.start()  # Start cooldown to reset hit

func pistol_hit():
	health -= 25 * Global.damage_buff
	is_hit = true  # Set hit flag to true
	$AnimationPlayer.play("hit")
	enemy_health()
	$AttackCooldown.start() # Start cooldown to reset hit

func smg_hit():
	health -= 15 * Global.damage_buff
	speed -= 5
	is_hit = true  # Set hit flag to true
	$AnimationPlayer.play("hit")
	enemy_health()
	$AttackCooldown.start() # Start cooldown to reset hit
	
func laser_hit():
	health -= 75 * Global.damage_buff
	speed -= 50
	is_hit = true  # Set hit flag to true
	$AnimationPlayer.play("hit")
	enemy_health()
	$AttackCooldown.start()  # Start cooldown to reset hit

func explosive_hit():
	health -= 150 * Global.damage_buff
	is_hit = true  # Set hit flag to true
	$AnimationPlayer.play("hit")
	enemy_health()
	$AttackCooldown.start()  # Start cooldown to reset hit

func enemy_health():
	if health <= 0:
		$PlayerDetction/CollisionShape2D.disabled = true
		$Hitbox.disabled = true
		$PlayerHit/AttackHitbox.disabled = true
		set_physics_process(false)
		$AnimationPlayer.play("death")
		$AttackCooldown.stop()
		Global.add_ammo()
		Global.score += 100
		if not Global.power_activate and Global.powerup_refill <= 100:
			Global.powerup_refill += 5
		await $AnimationPlayer.animation_finished
		queue_free()
	
func _on_player_hit_body_entered(body: Node2D) -> void:
	if body.has_method("weak_hit"):
		body.weak_hit()
		

func _on_player_detction_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_detected = true
	if body.has_method("weak_hit") and attack_ready and player_detected:
		attack()

func _on_attack_cooldown_timeout() -> void:
	is_hit = false
	$PlayerHit/AttackHitbox.disabled = true
	if player_detected:
		attack()
	else:
		move_enemy()

func attack():
	attack_ready = false
	$AnimationPlayer.play("attack")
	$AttackCooldown.start()
	$PlayerHit/AttackHitbox.disabled = true

func _on_player_detction_body_exited(body: Node2D) -> void:
	attack_ready = true
	player_detected = false
	$AttackCooldown.stop()
	$PlayerHit/AttackHitbox.disabled = true
	move_enemy() 
