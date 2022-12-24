extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

export var jump_path : NodePath
onready var jump_state = get_node(jump_path)

export var tele_amount : int
export var jump_power : float

var ground_timer = 0.0
var jump_timer = 0.0

func _start(delta):
	jump_state.stage_num = 2
	sound.play_random()
	
	character.position.y -= tele_amount
	character.velocity.y = -jump_power

func _stop(delta):
	character.set_state_by_name("Fall", delta)
	character.get_state_node("Fall").animation = "jump"

func _stop_check(_delta):
	return character.velocity.y >= 0
