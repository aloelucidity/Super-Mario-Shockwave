extends State

export var movement_path : NodePath
onready var movement = get_node(movement_path)

export var hammer_path : NodePath
onready var hammer = get_node(hammer_path)

export var move_speed : float
export var rot_speed : float
export var spin_time : float
export var accel : float

var direction = 1
var stage = 0
var attack_timer = 0.0
var stop_timer = 0.0

var sprite

func _start_check(_delta):
	return attack_timer > 0

func _start(delta):
	stage = 0
	animation = "hammerwindup"
	sprite = character.get_node("AnimatedSprite")
	sprite.rotation_degrees = 0
	sprite.frame = 0
	
	direction = character.facing_direction

func _update(delta):
	var current_speed = move_speed if stage == 1 else move_speed / 1.4
	match stage:
		0:
			if sprite.frame == 5:
				stop_timer = spin_time
				animation = "hammerspin"
				hammer.visible = true
				stage = 1
		1:
			character.facing_direction = direction
			sprite.rotation_degrees = lerp(sprite.rotation_degrees, 15 * direction, delta * rot_speed)
			stop_timer -= delta
		
	character.velocity.x = lerp(
		character.velocity.x, 
		current_speed * direction,
		delta * accel
	)
	character.velocity.y = 0

func _stop(delta):
	hammer.visible = false

func _stop_check(_delta):
	return stop_timer <= 0 && stage == 1

func _general_update(delta):
	if (character.inputs.attack[1] 
	&& movement.direction != 0 
	&& character.grounded
	&& (character.state == null || !character.state.name in blacklisted_states)
	):
		attack_timer = 0.2
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attack_timer = 0
