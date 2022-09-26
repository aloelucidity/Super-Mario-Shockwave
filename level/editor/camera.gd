extends Camera2D

export var move_speed : float
export var fast_speed : float
export var zoom_speed : float

export var cursor_speed : float

func can_zoom():
	if Input.is_action_pressed("unlock_zoom") || !(Input.is_action_pressed("cursor_up") || Input.is_action_pressed("cursor_down")):
		return true
	return false

func change_zoom(zoom_amount):
	zoom += Vector2(zoom_amount, zoom_amount)
	get_parent().zoom = zoom

func _physics_process(_delta):
	if Input.is_action_pressed("zoom_out") && can_zoom():
		var zoom_amount = Input.get_action_strength("zoom_out")
		zoom_amount = math_util.change_max(zoom_amount, 1, zoom_speed)
		change_zoom(zoom_amount)

	if Input.is_action_pressed("zoom_in") && can_zoom():
		var zoom_amount = Input.get_action_strength("zoom_in")
		zoom_amount = math_util.change_max(zoom_amount, 1, zoom_speed)
		change_zoom(-zoom_amount)
	
	var camera_movement = input_util.get_vector("editor_right", "editor_left", "editor_down", "editor_up")
	if camera_movement.length() > 0.2:
		var is_speed = Input.is_action_pressed("editor_speed")
		var speed = (move_speed if !is_speed else fast_speed)
		camera_movement.x = math_util.change_max(camera_movement.x, 1, speed)
		camera_movement.y = math_util.change_max(camera_movement.y, 1, speed)
		position += camera_movement

#	var cursor_movement = input_util.get_vector("cursor_right", "cursor_left", "cursor_down", "cursor_up")
#	if cursor_movement.length() > 0.2 && !Input.is_action_pressed("unlock_zoom"):
#		cursor_movement.x = math_util.change_max(cursor_movement.x, 1, cursor_speed)
#		cursor_movement.y = math_util.change_max(cursor_movement.y, 1, cursor_speed)
#		cursor.position += cursor_movement
