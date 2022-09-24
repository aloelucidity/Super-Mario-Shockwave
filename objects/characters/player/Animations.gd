extends Node

onready var character = get_parent()

export(NodePath) var sprite_path
onready var sprite = get_node(sprite_path)

export(NodePath) var movement_path
onready var movement = get_node(movement_path)

# todo: rewrite
func update(_delta):
	if !is_instance_valid(character.state) || character.state.animation == "":
		if abs(character.velocity.x) > 0 && sprite.animation != "move" && character.grounded:
			sprite.play("move")
		
		elif abs(character.velocity.x) == 0 && sprite.animation != "idle" && character.grounded:
			sprite.play("idle")

		if sprite.animation == "move":
			sprite.speed_scale = clamp(abs(character.velocity.x) / movement.walk_speed, 1, INF)
		
		sprite.flip_h = (character.facing_direction == -1)
	else:
		sprite.speed_scale = character.state.speed_scale
		if sprite.animation != character.state.animation:
			sprite.play(character.state.animation)
		
		if character.state.autoflip:
			sprite.flip_h = (character.facing_direction == -1)
