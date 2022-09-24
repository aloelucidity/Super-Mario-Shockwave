extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

export var tele_amount : int
export var jump_power : float
export var launch_power : float
export var release_multiplier : float
export var rot_speed : float

var direction = 1
var released = false
var ground_timer = 0.0
var jump_timer = 0.0

var sprite

func _start(delta):
	sprite = character.get_node("AnimatedSprite")
	sprite.rotation_degrees = 0
	released = false
	sound.play_random()
	
	direction = character.facing_direction
	character.position.y -= tele_amount
	character.velocity.y = -jump_power
	character.velocity.x = launch_power * direction

func _update(delta):
	character.facing_direction = direction

	if !released && !character.inputs["jump"][0]:
		released = true
		character.velocity.y *= release_multiplier
	
	sprite.rotation = lerp(sprite.rotation, PI * 2 * direction, delta * rot_speed)
	
	if abs(sprite.rotation) < PI * 1.5:
		animation = "triplejump"
		disable_movement = true
	else:
		animation = "jump"
		disable_movement = false

func _stop(delta):
	character.set_state_by_name("Fall", delta)

func _stop_check(_delta):
	return character.grounded
