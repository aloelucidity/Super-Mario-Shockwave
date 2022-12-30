extends HBoxContainer

onready var area = get_parent().get_node("Area")
onready var level = get_parent().get_node("Level")

func open_area():
	area.visible = true
	level.visible = false

func open_level():
	area.visible = false
	level.visible = true
