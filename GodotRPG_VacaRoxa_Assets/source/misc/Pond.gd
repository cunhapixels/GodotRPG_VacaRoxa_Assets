extends StaticBody2D

func _on_Timer_timeout():
	if get_parent().get_node("Enemies").get_child_count() < 3:
		var slime = globals.PRE_SLIME.instance()
		slime.position = position
		
		var r = rand_range(0, 1.5)
		
		if r > 1:
			slime.red = true
		
		get_parent().get_node("Enemies").add_child(slime)
