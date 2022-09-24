extends Camera2D

var camera = null

func _process(delta):
	if !is_instance_valid(camera): return
	global_position = camera.global_position
