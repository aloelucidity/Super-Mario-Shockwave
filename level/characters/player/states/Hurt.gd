extends State

export var sound_path : NodePath
onready var sound = get_node(sound_path)

export var health_path : NodePath
onready var health = get_node(health_path)

export var effects_path : NodePath
onready var effects = get_node(effects_path)

export(Array, NodePath) var collider_paths
var colliders : Array

export var lerp_speed : float
export var tele_amount : Vector2
export var knockback : Vector2
export var hurt_time : float 

export var zoom_amount : Vector2
export var shake_intensity : float
export var shake_time : float

var direction : int = 1
var sprite
var hit_area
var timer

func _ready():
	for collider in collider_paths:
		colliders.append(get_node(collider))

func _start_check(delta):
	var is_colliding := false
	for collider in colliders:
		if collider.get_overlapping_areas().size() > 0:
			is_colliding = true
			hit_area = collider.get_overlapping_areas()[0]
	return is_colliding

func _start(delta):
	direction = sign(hit_area.global_position.x - character.global_position.x)
	health.ouch()
	
	sprite = character.get_node("AnimatedSprite")
	sprite.modulate = Color.red
	sprite.scale.x = 0.65
	sprite.offset.x = 10 * direction
	sprite.rotation_degrees = 0
	sound.play_random()
	effects.hit_effect()
	effects.hit_sound()
	
	character.grounded = false
	character.position -= Vector2(tele_amount.x * direction, tele_amount.y)
	character.velocity = Vector2(knockback.x * -direction, -knockback.y)
	timer = hurt_time

func _update(delta):
	sprite = character.get_node("AnimatedSprite")
	sprite.modulate = lerp(sprite.modulate, Color.white, delta * lerp_speed)
	timer -= delta

func _stop(_delta):
	sprite.modulate = Color.white

func _stop_check(_delta):
	return character.grounded || timer <= 0
