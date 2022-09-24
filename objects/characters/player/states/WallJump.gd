extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

export var movement_path : NodePath
onready var movement = get_node(movement_path)

export var slide_path : NodePath
onready var slide_state = get_node(slide_path)

export var tele_amount : Vector2
export var jump_power : Vector2
export var support_power : float
export var counter_power : float
export var release_multiplier : float

var released = false
var jump_timer = 0.0

var direction = 0
var sprite

func _start_check(delta):
	return jump_timer > 0 && slide_state.jump_checks(delta)

func _start(delta):
	direction = slide_state.direction
	
	sprite = character.get_node("AnimatedSprite")
	character.facing_direction = -direction
	sound.play_random()
	
	released = false
	jump_timer = 0
	slide_state.wall_timer = 0
	character.grounded = false

	character.position -= Vector2(tele_amount.x * direction, tele_amount.y)
	character.velocity = Vector2(jump_power.x * -direction, -jump_power.y)
	sprite.flip_h = (character.facing_direction == -1)

func _update(_delta):
	character.facing_direction = -direction
	if movement.direction == direction:
		character.velocity.x -= counter_power * direction
	elif movement.direction == -direction:
		character.velocity.x -= support_power * direction

	if !released && !character.inputs["jump"][0]:
		released = true
		character.velocity.y *= release_multiplier

func _stop(delta):
	character.set_state_by_name("Fall", delta)

func _stop_check(_delta):
	return character.velocity.y > 0 || character.grounded

func _general_update(delta):
	if character.inputs["jump"][1] && !character.grounded:
		jump_timer = 0.2
	
	if jump_timer > 0:
		jump_timer -= delta
		if jump_timer <= 0:
			jump_timer = 0

	if character.grounded:
		jump_timer = 0
