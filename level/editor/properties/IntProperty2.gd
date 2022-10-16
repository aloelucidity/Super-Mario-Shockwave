extends Control

var object
var key
var params

func load_property(_object, _key, label, _params):
	object = _object
	key = _key
	params = _params
	$Label.text = label
	$LineEdit.text = str(object.get_property(key))

func text_entered():
	set_property(int($LineEdit.text))

func set_property(val):
	object.set_property(key, clamp(val, params[0], params[1]))
	$LineEdit.text = str(object.get_property(key))

func increment_value(direction : int):
	var cur_val = object.get_property(key)
	cur_val += params[2] * direction
	set_property(cur_val)
