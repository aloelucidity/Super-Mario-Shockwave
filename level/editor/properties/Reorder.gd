extends Control

var object : Node

func to_back():
	object.get_parent().move_child(object, 0)

func to_front():
	object.get_parent().move_child(object, object.get_parent().get_child_count())
