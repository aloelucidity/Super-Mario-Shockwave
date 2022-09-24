extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

export var tele_amount : int
export var jump_power : float
export var rot_speed : float

var direction = 1
var sprite

func _start(delta):
	direction = character.facing_direction
	sprite = character.get_node("AnimatedSprite")
	sprite.rotation = 0
	sound.play_random()

	character.position.y -= tele_amount
	character.velocity.y = -jump_power

func _update(delta):
	sprite.rotation = lerp(sprite.rotation, PI * 2 * direction, delta * rot_speed)
	
	if abs(sprite.rotation) < PI * 1.5:
		animation = "triplejump"
	else:
		animation = "jump"

func _stop(delta):
	character.set_state_by_name("Fall", delta)

func _stop_check(_delta):
	return character.velocity.y >= 0 || abs(sprite.rotation) > PI * 1.9 
