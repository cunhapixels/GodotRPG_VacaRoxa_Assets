extends KinematicBody2D

const MOVE_SPEED = 120

var motion = Vector2.ZERO

func _process(delta):
	move()
	move_and_slide(motion)

func move():
	var move = Vector2.ZERO
	move.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if move != Vector2.ZERO:
		get_node("AnimationPlayer").play("Walk")
		
		if move.x != 0:
			get_node("Sprite").scale.x = move.x
	else:
		get_node("AnimationPlayer").play("Idle")
	
	motion = MOVE_SPEED * move.normalized()