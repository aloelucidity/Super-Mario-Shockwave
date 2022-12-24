extends Node

export(int) var hp = 3
onready var character = get_parent()

var anim_playing : bool

func ouch(damage : int = 1, knockback : float = 0, hurt_from : Vector2 = Vector2.ZERO):
	hp = clamp(hp - damage, 0, 3)
	Globals.level.emit_signal("health_changed", hp)
