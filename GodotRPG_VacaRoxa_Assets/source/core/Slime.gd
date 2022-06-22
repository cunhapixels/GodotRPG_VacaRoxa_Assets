extends KinematicBody2D

var direction = Vector2.ZERO
var length = 0
var hp = 2

func _process(delta):
	if length > 0:
		position += direction * length
		length -= delta * 2
	
	if hp <= 0:
		queue_free()


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Stick"):
		hp -= 1
		direction = -(area.position - position).normalized()
		length = 1.2
		
		area.queue_free()
