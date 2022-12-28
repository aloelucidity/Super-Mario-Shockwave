extends Button

func _physics_process(delta):
	if is_hovered():
		self_modulate = lerp(self_modulate, Color(0.7, 0.7, 0.7), delta * 6)
	else:
		self_modulate = lerp(self_modulate, Color.white, delta * 6)
	
	if pressed:
		self_modulate = Color.white
