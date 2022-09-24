extends Node2D

func click(cursor, obj_id):
	var level = get_parent().level
	var area = level.get_area(level.persistent_data.current_area)
	var data = {
		"type_id": obj_id,
		"base_properties": {
			"position": cursor
		}
	}
	area.add_object(data, true)
