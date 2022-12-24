extends Camera2D

export var follow_path : NodePath
onready var follow = get_node(follow_path)

export var follow_speed : float
export var zoom_speed : float
export var zoom_smoothing : float

export var shake_intensity : float
export var shake_time : float

var current_zoom : Vector2

func _ready():
	current_zoom = Vector2.ONE
	if "camera" in follow:
		follow.camera = self

func _physics_process(delta):
	position.x = lerp(position.x, follow.global_position.x, delta * follow_speed)
	position.y = lerp(position.y, follow.global_position.y, delta * follow_speed)
	
	if Input.is_action_pressed("zoom_out"):
		var zoom_amount = Input.get_action_strength("zoom_out")
		zoom_amount = math_util.change_max(zoom_amount, 1, zoom_speed)
		current_zoom += Vector2(zoom_amount, zoom_amount)
	if Input.is_action_pressed("zoom_in"):
		var zoom_amount = Input.get_action_strength("zoom_in")
		zoom_amount = math_util.change_max(zoom_amount, 1, zoom_speed)
		current_zoom -= Vector2(zoom_amount, zoom_amount)
	
	zoom.x = lerp(zoom.x, current_zoom.x, delta * zoom_smoothing)
	zoom.y = lerp(zoom.y, current_zoom.y, delta * zoom_smoothing)
	if shake_time > 0:
		shake_update(delta)

func shake_update(delta):
	var intensity = shake_intensity * shake_time
	offset.x = rand_range(0, 1) * intensity
	offset.y = rand_range(0, 1) * intensity
	
	shake_time -= delta
	if shake_time <= 0:
		offset = Vector2()
