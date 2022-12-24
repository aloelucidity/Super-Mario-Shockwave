extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

var stage_num = 0
var reset_timer = 0.0

export var tele_amount : int
export var jump_power : float
export var release_multiplier : float
export var min_triple_speed : float

var released = false
var ground_timer = 0.0
var jump_timer = 0.0

func _start_check(_delta):
	return jump_timer > 0 && ground_timer > 0

func _start(delta):
	released = false
	jump_timer = 0
	ground_timer = 0
	character.grounded = false

	if stage_num <= 0:
		stage_num = 1
		sound.play_random()
		character.position.y -= tele_amount
		character.velocity.y = -jump_power
	elif stage_num == 1 || (stage_num == 2 && abs(character.velocity.x) < min_triple_speed):
		stage_num = 2
		character.set_state_by_name("DoubleJump", delta)
	else:
		stage_num = 0
		character.set_state_by_name("TripleJump", delta)

func _update(_delta):
	if !released && !character.inputs["jump"][0]:
		released = true
		character.velocity.y *= release_multiplier

func _stop(delta):
	character.set_state_by_name("Fall", delta)
	character.get_state_node("Fall").animation = "jump"

func _stop_check(_delta):
	return character.velocity.y > 0 || character.grounded

func _general_update(delta):
	if character.grounded:
		ground_timer = 0.2
		if stage_num > 0:
			reset_timer -= delta
			if reset_timer <= 0:
				reset_timer = 0.4
				stage_num = 0
		else:
			reset_timer = 0.4
		
	if character.inputs["jump"][1]:
		jump_timer = 0.2
	
	if jump_timer > 0:
		jump_timer -= delta
		if jump_timer <= 0:
			jump_timer = 0
	
	if ground_timer > 0:
		ground_timer -= delta
		if ground_timer <= 0:
			ground_timer = 0
