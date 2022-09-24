extends AnimatedSprite

export var rot_speed : float
export var raycast_path : NodePath

onready var raycast = get_node(raycast_path)
onready var character = get_parent()

func _physics_process(delta):
	if character.state != null && character.state.override_rotation: return
	rotation = lerp_angle(rotation, get_angle() if character.grounded else 0, delta * rot_speed)

func get_angle():
	var normal = raycast.get_collision_normal()
	var angle = (atan2(normal.y, normal.x) + (PI/2)) / 2
	return angle
