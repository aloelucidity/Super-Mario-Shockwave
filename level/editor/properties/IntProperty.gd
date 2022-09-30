extends Control

var object
var key
var buttons = []

func load_property(_object, _key, label, params):
	object = _object
	key = _key
	$Label.text = label
	for i in range(params[0]):
		var property_button = preload("res://level/editor/properties/square_button.tscn").instance()
		if i == object.properties[key]:
			property_button.texture_normal = preload("res://level/editor/boxoutline-2.png")
		property_button.get_node("Sprite").texture = load(object.object_path + "/icons/" + key + "/" + str(i) + ".png")
		property_button.connect("pressed", self, "change_property", [i])
		buttons.append(property_button)
		$ScrollContainer/HBoxContainer.add_child(property_button)

func change_property(id):
	buttons[object.properties[key]].texture_normal = preload("res://level/editor/boxoutline-1.png")
	buttons[id].texture_normal = preload("res://level/editor/boxoutline-2.png")
	object.change_property(key, id)
