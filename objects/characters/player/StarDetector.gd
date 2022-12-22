extends Area2D

onready var character = get_parent()

func area_entered(area):
	Engine.time_scale = 1
	$CollisionShape2D.disabled = true
	character.global_position = area.global_position
	character.frozen = true
	character.visible = false
	area.get_parent().queue_free()
	
	var star_collect = preload("res://objects/characters/player/star_collect.tscn").instance()
	var animation_player = star_collect.get_node("AnimationPlayer")
	var camera = star_collect.get_node("Camera2D")
	character.get_parent().add_child(star_collect)
	
	Globals.level.stop_music()
	Globals.level.hide_hud()
	star_collect.global_position = character.global_position
	animation_player.play("collect")
	
