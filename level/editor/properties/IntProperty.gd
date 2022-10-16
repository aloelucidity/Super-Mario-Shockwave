extends Control

var object
var key
var buttons = []

var y_size

func _init():
	y_size = rect_min_size.y

func load_property(_object, _key, label, params):
	object = _object
	key = _key
	$Label.text = label
	for i in range(params[0]):
		var property_button = preload("res://level/editor/properties/square_button.tscn").instance()
		if i == object.get_property(key):
			property_button.texture_normal = preload("res://level/editor/boxoutline-2.png")
			property_button.texture_hover = preload("res://level/editor/boxoutline_press.png")
		property_button.get_node("Sprite").texture = load(object.object_path + "/icons/" + key + "/" + str(i) + ".png")
		property_button.connect("pressed", self, "set_property", [i])
		buttons.append(property_button)
		$ScrollContainer/HBoxContainer.add_child(property_button)
	if params[0] < 4:
		rect_min_size.y = y_size - 10

func set_property(id):
	buttons[object.get_property(key)].texture_normal = preload("res://level/editor/boxoutline-1.png")
	buttons[object.get_property(key)].texture_hover = preload("res://level/editor/boxoutline_hover.png")
	buttons[id].texture_normal = preload("res://level/editor/boxoutline-2.png")
	buttons[id].texture_hover = preload("res://level/editor/boxoutline_press.png")
	object.set_property(key, id)
