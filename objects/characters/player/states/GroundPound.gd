extends State

export var tele_amount : int
export var rot_speed : float
export var stomp_power : float
export var getup_time : float

export var shake_intensity : float
export var shake_time : float

var rotating : bool
var direction : int = 1
var landed : bool
var sprite

var input_timer = 0.0
var getup_timer = 0.0
var jump_timer = 0.0

func _start_check(delta):
	return input_timer > 0 && !character.grounded

func _start(delta):
	direction = character.facing_direction
	input_timer = 0
	getup_timer = getup_time
	
	sprite = character.get_node("AnimatedSprite")
	sprite.rotation = 0
	rotating = true
	landed = false
	
	character.position.y -= tele_amount
	character.velocity = Vector2()
	gravity_multiplier = 0
	
	animation = "gpstart"
	disable_movement = true

func _update(delta):
	if !landed:
		if rotating:
			sprite.rotation = lerp(sprite.rotation, PI * 2 * direction, delta * rot_speed)
		
		if abs(sprite.rotation) > PI * 1.99 || character.grounded:
			rotating = false
			sprite.rotation = 0
			gravity_multiplier = 1
			character.velocity.y = stomp_power
			
			animation = "groundpound"
			disable_movement = false
		
		if character.grounded:
			landed = true
			disable_movement = true
			character.shake_camera(shake_intensity, shake_time)
	else:
		if jump_timer > 0:
			jump_timer = 0
			character.grounded = false
			character.set_state_by_name("GroundPoundJump", delta)

func _stop_check(_delta):
	return getup_timer <= 0

func _general_update(delta):
	if character.inputs["stomp"][1]:
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

	if getup_timer > 0 && character.grounded:
		getup_timer -= delta
		if getup_timer <= 0:
			getup_timer = 0
	
	if character.grounded:
		input_timer = 0
