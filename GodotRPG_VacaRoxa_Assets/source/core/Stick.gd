extends Area2D

var motion = Vector2.ZERO

func _process(delta):
	if position.x < 0 or position.x > 320:
		queue_free()
	
	get_node("Sprite").rotation_degrees += 15
	position += motion * delta


func _on_Stick_body_entered(body):
	if body.name == "Collisions":
		queue_free()
