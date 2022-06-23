extends Area2D

var motion : Vector2 = Vector2(0.25, -0.5)

func _ready():
	var cur_color = Color(modulate.r, modulate.g, modulate.b, modulate.a)
	var targ_color = Color(modulate.r, modulate.g, modulate.b, 0.0)
	get_node("Tween").interpolate_property(self, "modulate", cur_color, targ_color, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4)
	get_node("Tween").start()

func _process(delta):
	motion.y += 0.05
	if modulate.a <= 0.05:
		queue_free()
	
	position += motion
