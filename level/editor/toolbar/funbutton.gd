extends TextureButton

func _physics_process(delta):
	if is_hovered():
		rect_scale = lerp(rect_scale, Vector2(1.15, 1.15), delta * 6)
	else:
		rect_scale = lerp(rect_scale, Vector2(1, 1), delta * 6)
