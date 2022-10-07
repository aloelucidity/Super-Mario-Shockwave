extends Node2D

var is_bg = false
var texture_id = 0
var obj_id = 3
var points = []

func click(cursor):
	var click_range = 16 * get_parent().zoom.x
	if points.size() > 2:
		var first_point = points[0]
		if cursor.x > (first_point.x - click_range) && cursor.x < first_point.x + click_range:
			if cursor.y > (first_point.y - click_range) && cursor.y < first_point.y + click_range:
				add_terrain()
				return
	points.append(cursor)

func _draw():
	if points.size() <= 0: return
	if points.size() >= 2:
		draw_polyline(PoolVector2Array(points), Color.yellow, 2 * get_parent().zoom.x, true)
	draw_circle(points[0], 4 * get_parent().zoom.x, Color.yellow)
	draw_circle(points[points.size() - 1], 4 * get_parent().zoom.x, Color.yellow)

func add_terrain():
	var level = get_parent().level
	var area = level.get_area(level.persistent_data.current_area)
	var data = {
		"type_id": 3,
		"properties": {
			"points": PoolVector2Array(points),
			"texture_id": texture_id
		},
		"base_properties": {}
	}
	if is_bg:
		data.properties.solid = false
		data.base_properties.z_index = -10
		data.base_properties.tint = Color.darkgray
	area.add_object(data, true)
	points.clear()

func _process(_delta):
	update()

func _unhandled_input(event):
	if event.is_action_pressed("cancel_action"):
		points.clear()

	if event.is_action_pressed("object_left"):
		texture_id = wrapi(texture_id - 1, 0, 5)
		get_parent().update_icon(texture_id)
		
	if event.is_action_pressed("object_right"):
		texture_id = wrapi(texture_id + 1, 0, 5)
		get_parent().update_icon(texture_id)

	if event.is_action_pressed("object_mode"):
		is_bg = !is_bg
		get_parent().update_icon(texture_id)
