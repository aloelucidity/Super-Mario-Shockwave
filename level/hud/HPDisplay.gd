extends Control

onready var inner = $Inner
onready var hp_val = $HPVal
var inner_clone

export(float) var lerp_speed
export(Array, Color) var colors
var target_color : Color
var target_intensity : float
var shake_intensity : float

var base_pos : Vector2

func _init():
	base_pos = rect_position

func _ready():
	var hp = 3
	while true:
		set_hp_value(hp)
		hp -= 1
		hp = wrapi(hp, 0, 4)
		yield(get_tree().create_timer(2), "timeout")

func set_hp_value(hp : int):
	if hp < (target_intensity - 1):
		if !is_instance_valid(inner_clone):
			inner_clone = inner.duplicate()
			inner_clone.scale = Vector2.ONE
			inner_clone.position = Vector2.ZERO
			inner.add_child(inner_clone)
		shake_intensity = 0.25
	
	target_color = colors[hp]
	target_intensity = hp + 1
	hp_val.text = str(hp)
	inner.region_rect.position.x = inner.region_rect.size.x * hp

func get_param_intensity():
	return inner.material.get_shader_param("intensity")

func set_param_intensity(intensity : float):
	inner.material.set_shader_param("intensity", intensity)

func get_param_color():
	var color : Color
	color.r = inner.material.get_shader_param("r_vertical")
	color.g = inner.material.get_shader_param("g_vertical")
	color.b = inner.material.get_shader_param("b_vertical")
	return color

func set_param_color(color : Color):
	inner.material.set_shader_param("r_vertical", color.r)
	inner.material.set_shader_param("g_vertical", color.g)
	inner.material.set_shader_param("b_vertical", color.b)

func _physics_process(delta):
	if is_instance_valid(inner_clone):
		inner_clone.modulate.a = lerp(inner_clone.modulate.a, 0, delta * (lerp_speed / 2))
		if inner_clone.modulate.a <= 0.05:
			inner_clone.queue_free()
	
	if shake_intensity > 0:
		shake_intensity -= delta
		rect_position = base_pos + Vector2(
			shake_intensity * 10 * rand_range(-1, 1), 
			shake_intensity * 10 * rand_range(-1, 1)
		)
	
	var color = get_param_color()
	var intensity = get_param_intensity()
	if (color == target_color && intensity == target_intensity): return
	
	color = lerp(color, target_color, delta * lerp_speed)
	intensity = lerp(intensity, target_intensity, delta * lerp_speed)
	set_param_color(color)
	set_param_intensity(intensity)
