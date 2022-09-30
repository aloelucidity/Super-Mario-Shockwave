extends Control

export var speed : float
var shown : bool = true

func _physics_process(delta):
	if shown:
		rect_position.y = lerp(rect_position.y, 0, delta * speed)
	else:
		rect_position.y = lerp(rect_position.y, -35, delta * speed)

func toggle_visibility(value):
	shown = value

#func _ready():
#	get_parent().get_node("WindowDialog").popup()
