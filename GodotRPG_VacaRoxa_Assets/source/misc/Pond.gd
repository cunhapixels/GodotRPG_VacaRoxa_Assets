extends StaticBody2D

const PRE_SLIME = preload("res://source/core/Slime.tscn")

func _on_Timer_timeout():
	if get_parent().get_node("Enemies").get_child_count() < 3:
		var slime = PRE_SLIME.instance()
		slime.position = position
		
		var r = rand_range(0, 1.5)
		
		if r > 1:
			slime.red = true
		
		get_parent().get_node("Enemies").add_child(slime)
