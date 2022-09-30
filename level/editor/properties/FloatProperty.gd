extends Control

var object
var key
var params

func load_property(_object, _key, label, _params):
	object = _object
	key = _key
	params = _params
	$Label.text = label
	$LineEdit.text = str(object.properties[key])

func text_entered():
	change_property(float($LineEdit.text))

func change_property(val):
	object.change_property(key, clamp(val, params[0], params[1]))
	$LineEdit.text = str(object.properties[key])

func increment_value(direction : int):
	var cur_val = object.properties[key]
	cur_val += params[2] * direction
	change_property(cur_val)
