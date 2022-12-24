extends State

export var reg_group_path : NodePath
export var dive_group_path : NodePath
onready var reg_group = get_node(reg_group_path)
onready var dive_group = get_node(dive_group_path)

export var raycasts_path : NodePath
onready var raycasts_node = get_node(raycasts_path)
var old_raycasts

export var detector_path : NodePath
onready var water_detector = get_node(detector_path)

export var accel : float
export var decel : float
export var swim_speed : float
export var friction : float
export var rot_speed : float

var direction : Vector2
var rotation : float

var sprite
var speed : float

func dive_collision():
	old_raycasts = character.raycasts_node
	raycasts_node.visible = true
	old_raycasts.visible = false
	
	character.raycasts_node = raycasts_node
	sprite.raycast = raycasts_node.get_children()[0]
	for collider in reg_group.colliders:
		reg_group.get_node(collider).disabled = true
		reg_group.get_node(collider).visible = false
	for collider in dive_group.colliders:
		dive_group.get_node(collider).disabled = false
		dive_group.get_node(collider).visible = true

func reg_collision():
	raycasts_node.visible = false
	old_raycasts.visible = true
	
	character.raycasts_node = old_raycasts
	sprite.raycast = old_raycasts.get_children()[0]
	for collider in reg_group.colliders:
		reg_group.get_node(collider).disabled = false
		reg_group.get_node(collider).visible = true
	for collider in dive_group.colliders:
		dive_group.get_node(collider).disabled = true
		dive_group.get_node(collider).visible = false

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

func _start_check(_delta):
	return water_detector.get_overlapping_areas().size() > 0

func _start(_delta):
	sprite = character.get_node("AnimatedSprite")
	rotation = PI/2 * character.facing_direction
	dive_collision()

func _update(delta):
	direction = Vector2()
	if character.inputs["move_left"][0]:
		direction.x -= 1
	if character.inputs["move_right"][0]:
		direction.x += 1
	if character.inputs["move_up"][0]:
		direction.y -= 1
	if character.inputs["move_down"][0]:
		direction.y += 1
	direction = direction.normalized()
	
	if direction != Vector2():
		rotation = Vector2().angle_to_point(direction) - (PI/2)
	sprite.rotation = fmod(lerp_angle(sprite.rotation, rotation, delta * rot_speed), 360)

#	if abs(sprite.rotation) > PI:
#		sprite.rotation = -sprite.rotation

	var move_dir = Vector2.RIGHT.rotated(sprite.rotation - (PI/2))
	if character.inputs["jump"][0]:
		speed = increment_towards(speed, swim_speed, accel)
		if abs(character.velocity.x) < speed:
			character.velocity.x = speed * move_dir.x
		if abs(character.velocity.y) < speed:
			character.velocity.y = speed * move_dir.y
	else:
		speed = increment_towards(speed, 0, decel)
	character.velocity = character.velocity.move_toward(Vector2(), delta * friction)
	
	character.facing_direction = sign(sprite.rotation)

func _stop(_delta):
	reg_collision()

func _stop_check(_delta):
	return water_detector.get_overlapping_areas().size() <= 0
