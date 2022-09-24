extends TextureRect

export var cam_path : NodePath
onready var camera = get_node(cam_path)

func _process(delta):
	var camera_size = Vector2(512, 288) * camera.zoom
	var camera_pos = camera.global_position - (camera_size / 2)
	
	rect_size = Vector2(512 + 64, 288 + 64) * camera.zoom
	rect_position = Vector2(stepify(camera_pos.x - 32, 32), stepify(camera_pos.y - 32, 32))
