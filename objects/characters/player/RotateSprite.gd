extends AnimatedSprite

export var rot_speed : float
export var scale_speed : float
export var raycast_path : NodePath

onready var raycast = get_node(raycast_path)
onready var character = get_parent()

func _physics_process(delta):
	if character.state == null || !character.state.override_rotation:
		rotation = lerp_angle(rotation, get_angle() if character.grounded else 0, delta * rot_speed)
	if character.state == null || !character.state.override_scale:
		scale.x = lerp(scale.x, 1, delta * scale_speed)
		scale.y = lerp(scale.y, 1, delta * scale_speed)
		offset.x = lerp(offset.x, 0, delta * scale_speed)
		offset.y = lerp(offset.y, 0, delta * scale_speed)

func get_angle():
	var normal = raycast.get_collision_normal()
	var angle = (atan2(normal.y, normal.x) + (PI/2)) / 2
	return angle
