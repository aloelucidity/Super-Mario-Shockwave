extends Node
class_name LevelArea

onready var id_map = preload("res://level/objects/IDMap.tres")

export var id : int = 0
export(Array, Dictionary) var object_data
export var music_id : int = -1
export var music_volume : float = -4
export var background_id : int
export var foreground_id : int
export var effect_id : int

var current_mode : int = 1
var objects_node

func save_area():
	var data = {
		"music_id": music_id,
		"music_volume": music_volume,
		"background_id": background_id,
		"foreground_id": foreground_id,
		"effect_id": effect_id,
		"objects": []
	}
	for object in objects_node.get_children():
		data.objects.append(object.save_properties())
	
	return data

func load_area(data : Dictionary = {}):
	if data.size() > 0:
		object_data = data.objects
	if data.size() > 2:
		background_id = data.background_id
		foreground_id = data.foreground_id
		effect_id = data.effect_id
	if "music_id" in data:
		music_id = data.music_id
	if "music_volume" in data:
		music_volume = data.music_volume
	
	objects_node = Node2D.new()
	objects_node.name = "Objects"
	call_deferred("add_child", objects_node)
	
	for data in object_data:
		call_deferred("add_object", data)

func add_object(data : Dictionary, add_to_data : bool = false):
	var obj_name = id_map.ids[data.type_id]
	var obj_instance = Node2D.new()
	obj_instance.set_script(load("res://level/objects/" + obj_name +  "/" + obj_name + ".gd"))
	obj_instance.current_mode = current_mode
	obj_instance.load_properties(data)
	obj_instance.load_object()
	objects_node.add_child(obj_instance)
	
	if add_to_data:
		object_data.append(obj_instance.save_properties())

func delete_object(object : Object, remove_from_data : bool = false):
	if remove_from_data:
		object_data.erase(object.save_properties())
	object.queue_free()
