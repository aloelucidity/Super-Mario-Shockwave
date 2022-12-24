extends State

export var tele_amount : int
export var boost_power : Vector2

export var hitbox_start : float
export var hitbox_end : float

export var zoom_amount : float
export var time_scale : float
export var lerp_speed : float
export var shake_intensity : float

export var effects_path : NodePath
onready var effects = get_node(effects_path)

export var hitbox_path : NodePath
onready var hitbox = get_node(hitbox_path)

var attack_timer : float
var elapsed_time : float
var sprite

func _start_check(_delta):
	return attack_timer > 0

func _start(_delta):
	character.grounded = false
	attack_timer = 0
	elapsed_time = 0

	sprite = character.get_node("AnimatedSprite")
	sprite.frame = 0
	character.velocity.x -= boost_power.x * character.facing_direction
	character.velocity.y = -boost_power.y
	character.position.y -= tele_amount
	hitbox.disabled = true

func _update(delta):
	elapsed_time += delta
	if elapsed_time > hitbox_end && !hitbox.disabled:
		hitbox.disabled = true
	elif elapsed_time > hitbox_start && elapsed_time < hitbox_end && hitbox.disabled:
		hitbox.disabled = false
		hitbox.position.x = abs(hitbox.position.x) * character.facing_direction

func attack_connected(_area):
	effects.hit_effect(zoom_amount, time_scale, lerp_speed, shake_intensity)
	effects.hit_sound()

func _stop(_delta):
	hitbox.disabled = true

func _stop_check(_delta):
	return character.grounded

func _general_update(delta):
	if (character.inputs.move_up[0] 
		&& character.inputs.attack[1] 
		&& character.grounded 
	):
		attack_timer = 0.2
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attack_timer = 0
