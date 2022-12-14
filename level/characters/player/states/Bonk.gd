extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

export var dive_path : NodePath
onready var dive_state = get_node(dive_path)

export var rot_speed : float
export var tele_amount : Vector2
export var bonk_power : Vector2

var direction : int = 1
var sprite

func _start_check(delta):
	return character.state == dive_state && character.is_wall(character.facing_direction) && !character.grounded

func _start(delta):
	direction = character.facing_direction
	
	sprite = character.get_node("AnimatedSprite")
	sprite.scale.x = 0.65
	sprite.offset.x = 10 * direction
	sprite.rotation_degrees = 0
	sound.play_random()
	
	character.grounded = false
	character.position -= Vector2(tele_amount.x * direction, tele_amount.y)
	character.velocity = Vector2(bonk_power.x * -direction, -bonk_power.y)

func _update(delta):
	sprite.rotation_degrees -= rot_speed * direction

func _stop_check(_delta):
	return character.grounded
