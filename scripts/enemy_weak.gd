extends CharacterBody2D

@onready var target_scene = preload("res://scenes/player.tscn")
@onready var player_detection = $PlayerHit

var health = 500
var target: Node2D
var speed = 150
var is_hit = false  # Flag to check if the character is hit

func _ready():
	# Instance the player and add it to the scene
	target = target_scene.instantiate() as Node2D

func _physics_process(delta):
	if not is_hit:  # Only move if not hit
		if target:  # Ensure target exists
			# Calculate horizontal direction only
			var direction_x = (target.position.x - position.x)
			direction_x = direction_x / abs(direction_x) if direction_x != 0 else 0  # Normalize direction
			velocity.x = direction_x * speed
			velocity.y = 0  # Ensure no vertical movement
			$AnimationPlayer.play("walk")
		move_and_slide()
	else:
		velocity = Vector2.ZERO  # Stop movement

func melee_hit():
	health -= 200
	print("enemy was hit")
	is_hit = true  # Set hit flag to true
	$AnimationPlayer.play("hit")
	print(health)
	enemy_health()

func enemy_health():
	if health <= 0:
		$AnimationPlayer.play("death")

	
func _on_player_hit_body_entered(body: Node2D) -> void:
	if body.has_method("weak_hit"):
		$AnimationPlayer.play("attack")
		body.weak_hit()
		
