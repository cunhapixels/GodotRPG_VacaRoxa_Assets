extends KinematicBody2D

const EXPLOSION = preload("res://source/misc/Explosion.tscn")
const TEXT = preload("res://source/misc/FloatingText.tscn")

var direction = Vector2.ZERO
var length = 0
var hp = 50

var motion = Vector2.ZERO

func _process(_delta):
	if length > 0:
		motion = direction * length
		length *= 0.9
	
	if position.x < 0 or position.x > 320:
		direction *= -1
	if position.y < 0 or position.y > 180:
		direction *= -1
	
	if hp <= 0:
		var e = EXPLOSION.instance()
		e.position = position
		e.emitting = true
		get_parent().add_child(e)
		
		queue_free()
	
	motion = move_and_slide(motion)
	get_node("ProgressBar").value = hp * 20


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Stick"):
		var txt = TEXT.instance()
		txt.position = position
		get_parent().add_child(txt)
		
		hp -= area.damage
		direction = -(area.position - position).normalized()
		length = 150
		get_node("AnimationPlayer").play("Hit")
		
		#area.queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		get_node("AnimationPlayer").play("Bounce")
