extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

export var tele_amount : int
export var jump_power : float
export var release_multiplier : float

var released = false
var ground_timer = 0.0
var jump_timer = 0.0

func _start(delta):
	released = false
	sound.play_random()
	character.position.y -= tele_amount
	character.velocity.y = -jump_power

func _update(_delta):
	if !released && !character.inputs["jump"][0]:
		released = true
		character.velocity.y *= release_multiplier

func _stop(delta):
	character.get_state_node("Fall").animation = "doublefall"
	character.set_state_by_name("Fall", delta)

func _stop_check(_delta):
	return character.velocity.y > 0 || character.grounded
