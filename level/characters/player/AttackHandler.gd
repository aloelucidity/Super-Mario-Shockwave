extends Node

onready var character = get_parent()

func attack_connected(area):
	if character.state != null && character.state.has_method("attack_connected"):
		character.state.attack_connected(area)
