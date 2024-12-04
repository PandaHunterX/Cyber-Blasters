extends Node

@onready var weak_enemy = preload("res://scenes/enemy_weak.tscn")
@onready var fast_enemy = preload("res://scenes/enemy_fast.tscn")
@onready var hard_enemy = preload("res://scenes/enemy_hard.tscn")
@onready var player_position = preload("res://scenes/player.tscn")
@onready var dead_body = preload("res://scenes/dead_body.tscn")
@onready var background_music: AudioStreamPlayer2D = $"Player/Background Music"

var body_ready =  false

func _ready() -> void:
	background_music.play()
	$Respawn.start()
	$DifficultyTimer.start()
	$Fast_Respawn.start()
	$Hard_Respawn.start()
	
func _process(delta: float) -> void:
	if Global.player_drop_body:
		var body = dead_body.instantiate()
		body.position = $Player.global_position
		add_child(body)
		Global.player_drop_body = false

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
			var random_x_offset = Global.rng.randi_range(-600, 600)
			weak.position = $Player/Spawner.global_position + Vector2(random_x_offset, 0)
			add_child(weak)

func spawn_fast_enemy() -> void:
	if not Global.player_isdead:
		var num_enemies = Global.rng.randi_range(Global.fast_spawn_min, Global.fast_spawn_max)
		for i in range(num_enemies):
			var fast = fast_enemy.instantiate()
		# Randomize the position only along the X-axis
			var random_x_offset = Global.rng.randi_range(-600, 600)
			fast.position = $Player/Spawner.global_position + Vector2(random_x_offset, 0)
			add_child(fast)
			
func spawn_hard_enemy() -> void:
	if not Global.player_isdead:
		var num_enemies = Global.rng.randi_range(Global.hard_spawn_min, Global.hard_spawn_max)
		for i in range(num_enemies):
			var hard = hard_enemy.instantiate()
		# Randomize the position only along the X-axis
			var random_x_offset = Global.rng.randi_range(-600, 600)
			hard.position = $Player/Spawner.global_position + Vector2(random_x_offset, 0)
			add_child(hard)
			
func _on_respawn_timeout() -> void:
	spawn_weak_enemy()
	# Set a random wait time between 1 and 5 seconds
	$Respawn.wait_time = Global.rng.randi_range(Global.easy_sec_min, Global.easy_sec_max)
	$Respawn.start()  # Ensure the timer restarts if not done automatically


func _on_difficulty_timer_timeout() -> void:
	Global.difficulty_level()


func _on_fast_respawn_timeout() -> void:
	if Global.laser_rifle_unlock and (Global.difficulty >= 5 or Global.score >= 2000):
		spawn_fast_enemy()
	$Fast_Respawn.wait_time = Global.rng.randi_range(Global.fast_sec_min, Global.fast_sec_max)
	$Fast_Respawn.start()


func _on_hard_respawn_timeout() -> void:
	if Global.grenade_launcher_unlock and (Global.difficulty >= 10 or Global.score >= 5000):
		spawn_hard_enemy()
	$Hard_Respawn.wait_time = Global.rng.randi_range(Global.hard_sec_min, Global.hard_sec_max)
	$Hard_Respawn.start()
