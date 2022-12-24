extends Node

export var sound_path : NodePath
onready var sound = get_node(sound_path)

export var sound_weak_path : NodePath
onready var sound_weak = get_node(sound_weak_path)

onready var character = get_parent()
export var lerp_speed : float

var time_lerp : bool

func hit_sound():
	sound.play_random()

func weak_hit_sound():
	sound_weak.play_random()

func hit_effect(
	zoom_amount : float = 0.1, 
	time_scale : float = 0.75,
	new_lerp_speed : float = 6,
	shake_intensity : float = 4,
	shake_time : float = 0.5
):
	character.shake_camera(shake_intensity, shake_time)
	character.camera.zoom = Vector2(character.camera.current_zoom - Vector2(zoom_amount, zoom_amount))
	Engine.time_scale = time_scale
	lerp_speed = new_lerp_speed
	time_lerp = true

func update(delta):
	if time_lerp:
		Engine.time_scale = lerp(Engine.time_scale, 1, delta * lerp_speed)
		if abs(1 - Engine.time_scale) < 0.02:
			Engine.time_scale = 1
			time_lerp = false
