extends Button

export var float_amount : float
export var float_speed : float

export var rot_amount : float
export var rot_speed : float

export var time_offset : float
var time_elapsed : float

var base_pos : float

export var target_scale : Vector2
export var can_press : bool

func _init():
	base_pos = rect_position.y
	target_scale = Vector2.ONE
	connect("pressed", self, "pressed")

func pressed():
	if !can_press: return
	rect_scale = Vector2(1.5, 1.5)
	target_scale = Vector2.ZERO

func _physics_process(delta):
	var scale_speed = 2 if target_scale == Vector2.ZERO else 6
	if is_hovered() && target_scale != Vector2.ZERO:
		self_modulate = lerp(self_modulate, Color(0.7, 0.7, 0.7), delta * 6)
		rect_scale = lerp(rect_scale, Vector2(1.05, 1.05), delta * scale_speed)
	else:
		self_modulate = lerp(self_modulate, Color.white, delta * 6)
		rect_scale = lerp(rect_scale, target_scale, delta * scale_speed)
	
	var time = time_offset + time_elapsed
	rect_position.y = base_pos + cos(time * float_speed) * float_amount
	rect_rotation = cos(time * rot_speed) * rot_amount
	time_elapsed += delta
	
	if abs(rect_scale.x) < 0.05:
		target_scale = Vector2.ONE
