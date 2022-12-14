extends Control

var object
var key
var params

func load_property(_object, _key, label, _params):
	object = _object
	key = _key
	params = _params
	$Label.text = label
	
	$HSlider.min_value = params[0]
	$HSlider.max_value = params[1]
	$HSlider.step = params[2]
	$HSlider.value = object.get_property(key)

func set_property(val):
	object.set_property(key, clamp(val, params[0], params[1]))
