extends CharacterBody2D

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

func _physics_process(delta):
		
	var horizontal_direction = Input.get_axis("move_right", "move_left")
	velocity.x = 300 * horizontal_direction
	move_and_slide()
	update_animations(horizontal_direction)
	
func update_animations(horizontal_direction):
	if horizontal_direction == 0:
		ap.play("idle")
	else:
		ap.play("run") 
	
