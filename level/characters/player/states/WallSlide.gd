extends State

export var jump_path : NodePath
onready var jump_state = get_node(jump_path)

export var velocity_multiplier : float
export var slide_multiplier : float
export var wall_grace : float

var wall_timer = 0.0
var direction = 0

func is_bump(delta):
	if character.velocity.y < 0:
		return character.test_move(character.get_transform(), Vector2(0, character.velocity.y * delta))
	else:
		return false

func _start_check(delta):
	return jump_checks(delta) && slide_checks()

func _start(_delta):
	if character.velocity.y > 0:
		character.velocity.y *= velocity_multiplier

func _update(_delta):
	character.facing_direction = direction
	if character.velocity.y > 0:
		gravity_multiplier = slide_multiplier
	else:
		gravity_multiplier = 1

func _stop_check(_delta):
	return wall_timer <= 0 || character.grounded

func _general_update(delta):
	if character.is_wall(character.facing_direction) && character.wall_type != 1:
		if wall_timer <= 0:
			direction = character.facing_direction
		wall_timer = wall_grace
	
	if wall_timer > 0:
		wall_timer -= delta
		if wall_timer <= 0:
			wall_timer = 0


func jump_checks(delta):
	return wall_timer > 0 && !character.grounded && !is_bump(delta)

func slide_checks():
	return character.velocity.y > 0 || character.state == jump_state
