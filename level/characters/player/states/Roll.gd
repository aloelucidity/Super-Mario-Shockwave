extends State

export var raycast_path : NodePath
onready var raycast = get_node(raycast_path)

export var jump_power : float
export var rot_speed : float

export var friction : float
export var slope_factor_up : float
export var slope_factor_down : float
var ground_speed : float
var ground_angle : float

var direction = 1
var ground_timer = 0.0
var jump_timer = 0.0

var sprite

func _start_check(_delta):
	return false#character.inputs["stomp"][1] && character.grounded

func _start(delta):
	sprite = character.get_node("AnimatedSprite")
	sprite.rotation_degrees = 0
	
	direction = character.facing_direction
	ground_speed = (abs(character.velocity.x) + abs(character.velocity.y)) / 2

func _update(delta):
	ground_speed = increment_towards(ground_speed, 0, friction)
	ground_speed -= slope_factor_down * sin(get_angle())
	
	character.velocity.x = ground_speed * cos(get_angle())
	character.velocity.y = ground_speed * -sin(get_angle())

func _stop(delta):
	character.set_state_by_name("DiveRecover", delta)

func _stop_check(_delta):
	return character.inputs["jump"][1]

func get_angle():
	var normal = raycast.get_collision_normal()
	var angle = atan2(normal.x, normal.y)
	if raycast.is_colliding():
		ground_angle = rad2deg(angle)
	return ground_angle

func increment_towards(start, target, increment):
	if start > target:
		start -= increment
		if start <= target:
			start = target
	
	elif start < target:
		start += increment
		if start >= target:
			start = target
	
	return start
