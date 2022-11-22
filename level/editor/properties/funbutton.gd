extends TextureButton

onready var sprite = $Sprite

func _physics_process(delta):
	if is_hovered():
		sprite.rect_scale = lerp(sprite.rect_scale, Vector2(1.1, 1.1), delta * 6)
	else:
		sprite.rect_scale = lerp(sprite.rect_scale, Vector2(1, 1), delta * 6)
