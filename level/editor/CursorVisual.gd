extends Sprite

export var follow_path : NodePath
onready var follow = get_node(follow_path)

func _process(delta):
	position = follow.get_global_transform_with_canvas().origin + Vector2(8, 8)
