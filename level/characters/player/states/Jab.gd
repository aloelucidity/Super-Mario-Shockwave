extends State

export var effects_path : NodePath
onready var effects = get_node(effects_path)

export var hitbox_path : NodePath
onready var hitbox = get_node(hitbox_path)

export var rush_hitbox_path : NodePath
onready var rush_hitbox = get_node(hitbox_path)

export var detector_path : NodePath
onready var interactable_detector = get_node(detector_path)

export var hitbox_start : float
export var hitbox_end : float

export var hit_timing : float
export var zoom_amount : float
export var time_scale : float
export var lerp_speed : float
export var shake_intensity : float

export var rush_hit_interval : float
export var rush_zoom_amount : float
export var rush_time_scale : float
export var rush_lerp_speed : float
export var rush_shake_intensity : float
export var rush_time : float

export var sprite_offset : Vector2
export var initial_scale : float

var direction = 1
var stage = 0
var attack_connected : bool
var attack_timer : float
var stop_timer : float
var next_hit : float
var elapsed_time : float

var sprite

func jab_start():
	sprite.frame = 0
	sprite.offset = Vector2(sprite_offset.x * character.facing_direction, sprite_offset.y)
	sprite.scale.x = initial_scale
	sprite.scale.y = 1
	sprite.offset.x -= sprite_offset.x * (1 - initial_scale)
	hitbox.disabled = true
	attack_connected = false
	stop_timer = 0.4
	elapsed_time = 0

func _start_check(_delta):
	return attack_timer > 0

func _start(delta):
	stage = 0
	animation = "jab1"
	sprite = character.get_node("AnimatedSprite")
	jab_start()
	
	character.velocity = Vector2.ZERO

func _update(delta):
	elapsed_time += delta
	stop_timer -= delta
	sprite.scale.x = lerp(sprite.scale.x, 1, delta * lerp_speed)
	sprite.offset.x = lerp(sprite.offset.x, sprite_offset.x * character.facing_direction, delta * lerp_speed)
	
	if stage == 2:
		next_hit -= delta
		if next_hit <= 0:
			rush_hitbox.disabled = !rush_hitbox.disabled
			next_hit = rush_hit_interval
	else:
		if elapsed_time > hitbox_end && !hitbox.disabled:
			hitbox.disabled = true
		elif elapsed_time > hitbox_start && elapsed_time < hitbox_end && hitbox.disabled:
			hitbox.disabled = false
			hitbox.position.x = abs(hitbox.position.x) * character.facing_direction
	match stage:
		0:
			if attack_timer > 0 && attack_connected && stop_timer <= hit_timing:
				stage = 1
				animation = "jab2"
				jab_start()
		1:
			if attack_timer > 0 && attack_connected && stop_timer <= hit_timing:
				stage = 2
				animation = "jabrush"
				jab_start()
				rush_hitbox.disabled = false
				stop_timer = rush_time

func attack_connected(_area):
	attack_connected = true
	if stage == 2:
		effects.hit_effect(rush_zoom_amount, rush_time_scale, rush_lerp_speed, rush_shake_intensity)
		effects.weak_hit_sound()
	else:
		effects.hit_effect(zoom_amount, time_scale, lerp_speed, shake_intensity)
		effects.hit_sound()

func _stop(delta):
	hitbox.disabled = true
	sprite.offset = Vector2.ZERO

func _stop_check(_delta):
	return stop_timer <= 0

func _general_update(delta):
	if (character.inputs.attack[1] 
	&& character.grounded
	&& !interactable_detector.get_overlapping_areas().size() > 0
	&& (character.state == null || !character.state.name in blacklisted_states)
	):
		attack_timer = 0.2
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attack_timer = 0
