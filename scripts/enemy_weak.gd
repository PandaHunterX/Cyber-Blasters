extends CharacterBody2D

@onready var target_scene = preload("res://scenes/player.tscn")
@onready var player_detection = $PlayerHit

var health = 500
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
	health -= 200
	print("enemy was hit")
	is_hit = true  # Set hit flag to true
	$AnimationPlayer.play("hit")
	print(health)
	enemy_health()

func enemy_health():
	if health <= 0:
		$PlayerDetction/CollisionShape2D.disabled = true
		$AnimationPlayer.play("death")
		$AttackCooldown.stop()
		$Death.start()
		
func _on_player_hit_body_entered(body: Node2D) -> void:
	if body.has_method("weak_hit"):
		body.weak_hit()
		pass
		

func _on_player_detction_body_entered(body: Node2D) -> void:
	player_detected = true
	if body.has_method("weak_hit") and attack_ready and player_detected:
		attack()
		
func _on_attack_cooldown_timeout() -> void:
	if player_detected:
		attack_ready = true
		attack() 

func attack():
	attack_ready = false
	$AnimationPlayer.play("attack")
	$AttackCooldown.start()
		

func _on_player_detction_body_exited(body: Node2D) -> void:
	attack_ready = true
	player_detected = false
	$AttackCooldown.stop()
	move_enemy() 


func _on_death_timeout() -> void:
	$Death.stop()
	queue_free()
