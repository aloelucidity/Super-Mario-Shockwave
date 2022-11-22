extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

export var reg_group_path : NodePath
export var dive_group_path : NodePath
onready var reg_group = get_node(reg_group_path)
onready var dive_group = get_node(dive_group_path)

export var raycasts_path : NodePath
onready var raycasts_node = get_node(raycasts_path)
var old_raycasts

export var jump_path : NodePath
onready var jump_state = get_node(jump_path)

export var dive_power : Vector2
export var dive_threshold : float
export var max_speed : float
export var tele_amount : int
export var jump_power : float
export var rot_speed : float
export var end_tele : int

var input_timer : float
var jump_timer : float
var direction : int

var sprite

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


func _start_check(_delta):
	return input_timer > 0

func _start(delta):
	sprite = character.get_node("AnimatedSprite")
	dive_collision()
	
	input_timer = 0
	jump_state.stage_num = 0
	direction = character.facing_direction
	
	if !character.grounded || abs(character.velocity.x) > dive_threshold:
		if character.grounded:
			character.position.y -= tele_amount
			character.velocity.y = -jump_power
		if abs(character.velocity.x) < max_speed:
			character.velocity.x += dive_power.x * direction
			if abs(character.velocity.x) > max_speed:
				character.velocity.x = max_speed * direction
		character.velocity.y += dive_power.y
		sound.play_random()

	if abs(character.velocity.x) > 25:
		sprite.scale.y = 1.2 if abs(character.velocity.x) > (dive_power.x + 120) else 1.1
	sprite.flip_h = (character.facing_direction == -1)

func _update(delta):
	sprite.scale.y = lerp(sprite.scale.y, 1, delta * 2)
	character.facing_direction = direction
	
	if !character.grounded:
		var angle = (character.velocity.y / 900) + PI/2
		sprite.rotation = lerp_angle(abs(sprite.rotation), angle, delta * rot_speed) * direction
	else:
		sprite.rotation = lerp_angle(sprite.rotation, sprite.get_angle() + ((PI/2) * direction), delta * rot_speed * 3)

func _stop(delta):
	reg_collision()
	
	sprite.scale.y = 1
	sprite.offset.y = 0
	character.position.y -= end_tele
	character.grounded = false
	if jump_timer > 0:
		jump_timer = 0
		
		var move_direction = 0
		if character.inputs["move_left"][0]:
			move_direction -= 1
		if character.inputs["move_right"][0]:
			move_direction += 1
		if move_direction != -direction && (!character.inputs["dive"][0] || abs(character.velocity.x) > 45):
			character.set_state_by_name("DiveRecover", delta)
		else:
			character.set_state_by_name("Backflip", delta)

func _stop_check(_delta):
	return character.grounded && ((abs(character.velocity.x) < 45 && !character.inputs["dive"][0] && !character.inputs["stomp"][0]) || jump_timer > 0)

func _general_update(delta):
	if character.inputs["dive"][1]:
		input_timer = 0.2
	
	if character.inputs["stomp"][1] && character.grounded && abs(character.velocity.x) < dive_threshold:
		input_timer = 0.2
	
	if input_timer > 0:
		input_timer -= delta
		if input_timer <= 0:
			input_timer = 0

	if character.inputs["jump"][1]:
		jump_timer = 0.2
	
	if jump_timer > 0:
		jump_timer -= delta
		if jump_timer <= 0:
			jump_timer = 0
