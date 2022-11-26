extends Node2D

onready var editor = get_tree().get_current_scene()

func click(cursor):
	var level = get_parent().level
	var area = level.get_area(level.persistent_data.current_area)
	var data = {
		"type_id": editor.cur_item.obj_id,
		"base_properties": {
			"position": cursor
		}
	}
	area.add_object(data, true)
