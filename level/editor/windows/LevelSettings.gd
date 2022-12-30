extends ScrollContainer

var level
var object_path = "res://level/backgrounds"
onready var container = $VBoxContainer
onready var line_property = preload("res://level/editor/properties/LineProperty.tscn")
onready var string_property = preload("res://level/editor/properties/StringProperty.tscn")

func get_property(key : String):
	return level[key]

func set_property(key : String, new_value):
	level[key] = new_value

func open(_level : Level):
	for child in container.get_children():
		child.queue_free()
	level = _level
	add_level_name()
	add_level_author()
	add_level_description()

func add_level_name():
	var property = line_property.instance()
	var params = []
	property.load_property(self, "level_name", "Level Name", params)
	container.add_child(property)

func add_level_author():
	var property = line_property.instance()
	var params = []
	property.load_property(self, "level_author", "Level Author", params)
	container.add_child(property)

func add_level_description():
	var property = string_property.instance()
	var params = []
	property.load_property(self, "level_description", "Level Description", params)
	container.add_child(property)
