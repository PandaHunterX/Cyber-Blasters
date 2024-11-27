extends Node

@onready var weak_enemy = preload("res://scenes/enemy_weak.tscn")
@onready var player_position = preload("res://scenes/player.tscn")

	
func _ready() -> void:
	$Respawn.start()
	$DifficultyTimer.start()

func _physics_process(delta: float) -> void:
		# Ensure the boundary only updates when the player is moving right
	if $Player.velocity.x > 0:
		$Boundary.position.x = $Player.global_position.x - 300
	else:
		# Optional: Handle cases when the player is not moving right
		pass
	
func spawn_weak_enemy() -> void:
	if not Global.player_isdead: 
		var num_enemies = Global.rng.randi_range(Global.easy_spawn_min, Global.easy_spawn_max)
		for i in range(num_enemies):
			var weak = weak_enemy.instantiate()
		# Randomize the position only along the X-axis
			var random_x_offset = Global.rng.randi_range(-300, 300)
			weak.position = $Player/Spawner.global_position + Vector2(random_x_offset, 0)
			add_child(weak)
		
		
func _on_respawn_timeout() -> void:
	spawn_weak_enemy()
	# Set a random wait time between 1 and 5 seconds
	$Respawn.wait_time = Global.rng.randi_range(Global.easy_sec_min, Global.easy_sec_max)
	$Respawn.start()  # Ensure the timer restarts if not done automatically


func _on_difficulty_timer_timeout() -> void:
	Global.increase_weak_level()
