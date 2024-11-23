extends CharacterBody2D
const JUMP_VELOCITY = -400.0
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

func _physics_process(delta):
		
	var horizontal_direction = Input.get_axis("left", "right")
	velocity.x = 300 * horizontal_direction
	

		
	move_and_slide()
	update_animations(horizontal_direction)
	
	var isLeft = velocity.x < 0
	sprite.flip_h = isLeft
	
	
	
func update_animations(horizontal_direction):
	if horizontal_direction == 0:
		ap.play("idle")
	else:
		ap.play("run") 
		

	
