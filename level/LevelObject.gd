extends Node2D
class_name LevelObject

# saved to level data
export var type_id : int = 0 # what kind of object it is
export var base_properties : Dictionary
export var base_list_path : String = "res://level/objects/BasePropertyList.tres"
var base_properties_list

export var properties : Dictionary
export var list_path : String
export var object_path : String
var properties_list

# not saved
var loaded = false
var current_mode = 1

# functions
func load_object():
	return self

# properties
func change_base_property(key : String, new_value):
	base_properties[key] = new_value
	match(key):
		"position":
			position = new_value
		"z_index":
			z_index = new_value
		"tint":
			modulate = new_value

func setup_base_properties():
	position = base_properties.position
	z_index = base_properties.z_index
	modulate = base_properties.tint

func change_property(key : String, new_value):
	properties[key] = new_value

# level data
func save_properties() -> Dictionary:
	var data = {
		"type_id": type_id,
		"base_properties": {},
		"properties": {},
		"list_path": list_path
	}
	for key in base_properties:
		if base_properties[key] != find_first_with_key(key, base_properties_list).default[0]:
			data.base_properties[key] = base_properties[key]
	for key in properties:
		if properties[key] != find_first_with_key(key, properties_list).default[0]:
			data.properties[key] = properties[key]
	
	return data

func load_properties(data : Dictionary):
	base_properties = {}
	properties = {}
	
	base_properties_list = load(base_list_path).properties
	for property in base_properties_list:
		base_properties[property.key] = property.default[0]
	
	if list_path != "":
		properties_list = load(list_path).properties
		for property in properties_list:
			properties[property.key] = property.default[0]
	
	type_id = data.type_id
	if "base_properties" in data:
		for key in data.base_properties.keys():
			base_properties[key] = data.base_properties[key]
	if "properties" in data:
		for key in data.properties.keys():
			properties[key] = data.properties[key]
	
	setup_base_properties()

func properties_ui_path():
	return object_path + "/PropertyUI.tres"

static func find_first_with_key(key : String, array : Array):
	for property in array:
		if property.key == key:
			return property
	return null
