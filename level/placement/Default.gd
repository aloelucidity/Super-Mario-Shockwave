extends Node2D

var obj_id = 0

func click(cursor):
	var level = get_parent().level
	var area = level.get_area(level.persistent_data.current_area)
	var data = {
		"type_id": obj_id,
		"base_properties": {
			"position": cursor
		}
	}
	area.add_object(data, true)

func _unhandled_input(event):
	if event.is_action_pressed("object_left"):
		if obj_id > 2:
			obj_id -= 1
		obj_id = wrapi(obj_id - 1, 0, 4)
		if obj_id > 2:
			obj_id += 1
		get_parent().update_icon(obj_id)
		
	if event.is_action_pressed("object_right"):
		if obj_id > 2:
			obj_id -= 1
		obj_id = wrapi(obj_id + 1, 0, 4)
		if obj_id > 2:
			obj_id += 1
		get_parent().update_icon(obj_id)
