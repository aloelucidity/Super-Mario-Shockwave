extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path) 

export var sound_donk_path : NodePath
onready var sound_donk = get_node(sound_donk_path) 

export var detector_path : NodePath
onready var interactable_detector = get_node(detector_path)

export var swing_time : float
export var swing_land_time : float
export var boost_power : float
export var land_multiplier : float
export var rot_speed : float

export var shake_intensity : float
export var shake_time : float

export var hit_frame : int

var attack_timer = 0.0
var end_timer = 0.0
var direction = 1
var was_grounded = false
var hit = false
var sprite

func _start_check(_delta):
	return attack_timer > 0

func _start(_delta):
	if character.inputs.move_up[0]:
		character.position.y -= 1
		character.grounded = false
			
	priority = 4
	attack_timer = 0
	speed_scale = 1
	sound.play_random()
	
	sprite = character.get_node("AnimatedSprite")
	was_grounded = character.grounded
	disable_movement = character.grounded
	end_timer = swing_time
	
	hit = false
	sprite.frame = 0
	if !character.grounded:
		character.velocity.y = -boost_power
		speed_scale = 0.75

func _update(delta):
	if was_grounded && !hit:
		if sprite.frame >= hit_frame:
			hit = true
			sound_donk.play_random()
			character.shake_camera(shake_intensity, shake_time)
	
	if character.grounded && !was_grounded && !hit:
		hit = true
		character.velocity.x *= land_multiplier
		end_timer = swing_land_time
		sound_donk.play_random()
		character.shake_camera(shake_intensity, shake_time)
		priority = 1

func _stop(_delta):
	priority = 4

func _stop_check(_delta):
	return end_timer <= 0 or (!character.grounded && was_grounded)

func _general_update(delta):
	if end_timer > 0 && character.grounded:
		end_timer -= delta
		if end_timer <= 0:
			end_timer = 0
			
	if (character.inputs.attack[1] 
	&& !(interactable_detector.get_overlapping_areas().size() > 0 && character.grounded)
	&& (character.state == null || !character.state.name in blacklisted_states)
	):
		attack_timer = 0.2
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attack_timer = 0
