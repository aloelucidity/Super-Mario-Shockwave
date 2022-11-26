extends Control

var object
var key
var params

func load_property(_object, _key, label, _params):
	object = _object
	key = _key
	params = _params
	$Label.text = label
	$TextEdit.text = object.get_property(key)

func set_property(val):
	object.set_property(key, val)
	$TextEdit.text = object.get_property(key)

func focus_exited():
	set_property($TextEdit.text)
