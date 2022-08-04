extends KinematicBody2D

const MOVE_SPEED = 120

var motion = Vector2.ZERO
var attack_delay = 0

var direction = Vector2.ZERO
var length = 0

func _process(delta):
	attack_delay -= delta
	if attack_delay <= 0 and length <= 0:
		move()
	
	if length > 0:
		motion = direction * length
		length -= 4
	
	attack()
	motion = move_and_slide(motion)

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
	
	motion = lerp(motion, MOVE_SPEED * move.normalized(), 0.2)

func attack():
	if Input.is_action_just_pressed("attack"):
		attack_delay = 0.5
		get_node("AnimationPlayer").play("Attack")
		
		var stick = globals.STICK.instance()
		stick.position = position
		stick.motion.x = get_node("Sprite").scale.x * 150
	
		stick.position = position + Vector2(10 * get_node("Sprite").scale.x, 0)
		get_parent().add_child(stick)
		
		motion = Vector2.ZERO


func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Enemy"):
		#TODO: Add life decrease
		direction = (position - area.get_parent().position).normalized()
		length = 100
		
		var txt = globals.TEXT.instance()
		txt.position = position
		get_parent().add_child(txt)
		
		get_parent().get_node("Camera").get_node("AnimationPlayer").play("Shake")
	if area.is_in_group("Stick"):
		direction = -(area.position - position).normalized()
		length = 20
