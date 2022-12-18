extends Node
class_name Level

export var game_version : String = "0.0.0"
export var level_name : String = "My Level"
export var level_author : String = "Unknown"
export var level_description : String = "This level does not have a description."
export var thumbnail_url : String

export(Array, Dictionary) var area_data
var area_node

var persistent_data : Dictionary = {
	"current_area": 0,
	"coins": 0
}

signal coin_collected
signal sign_opened
signal health_changed

func collect_coin(amount : int = 1):
	persistent_data.coins += amount
	emit_signal("coin_collected")

func save_level():
	var data = {
		"game_version": game_version,
		"level_name": level_name,
		"level_author": level_author,
		"level_description": level_description,
		"thumbnail_url": thumbnail_url,
		"area_data": []
	}
	for i in range(area_data.size()):
		var found_area = get_area(i)
		data.area_data.append(found_area.save_area())
	
	return data

func load_level(data : Dictionary = {}):
	if data.size() > 0:
		if data.has("game_version"):
			game_version = data.game_version
		level_name = data.level_name
		level_author = data.level_author
		level_description = data.level_description
		thumbnail_url = data.thumbnail_url
		area_data = data.area_data
	
	assert(persistent_data.current_area < area_data.size(), "ERROR: Area index is out of range!")
	
	var area_node = Node.new()
	area_node.name = str(persistent_data.current_area)
	area_node.set_script(preload("res://level/LevelArea.gd"))
	area_node.load_area(area_data[persistent_data.current_area])
	add_child(area_node)

func get_area(index):
	return get_node(str(index))
