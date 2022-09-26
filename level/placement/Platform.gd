extends Node2D

var points = []
var origin : Vector2

var done_button 

func _ready():
	done_button = get_node("../CanvasLayer/LineDone")
	done_button.connect("pressed", self, "add_platform")
	done_button.visible = false

func click(cursor, obj_id):
	var click_range = 16 * get_parent().zoom.x
	if points.size() > 2:
		var first_point = points[0]
		if cursor.x > (first_point.x - click_range) && cursor.x < first_point.x + click_range:
			if cursor.y > (first_point.y - click_range) && cursor.y < first_point.y + click_range:
				points.append(first_point)
				add_platform()
				return
	if points.size() == 0:
		origin = cursor
	points.append(cursor)
	done_button.visible = true

func _draw():
	if points.size() <= 0: return
	if points.size() >= 2:
		draw_polyline(PoolVector2Array(points), Color.yellow, 2 * get_parent().zoom.x, true)
	draw_circle(points[0], 4 * get_parent().zoom.x, Color.yellow)
	draw_circle(points[points.size() - 1], 4 * get_parent().zoom.x, Color.yellow)

func add_platform():
	var level = get_parent().level
	var area = level.get_area(level.persistent_data.current_area)
	
	for i in range(points.size()):
		points[i] -= origin
		
	var move_type = 1
	if points.size() < 2:
		move_type = 0
	if points[0] != points[points.size() - 1]:
		move_type = 2
		
	var data = {
		"type_id": 5,
		"base_properties": {
			"position": origin
		},
		"properties": {
			"points": PoolVector2Array(points),
			"move_type": move_type
		}
	}
	area.add_object(data, true)
	points.clear()
	done_button.visible = false

func _process(delta):
	update()

func _unhandled_input(event):
	if event.is_action_pressed("cancel_action"):
		points.clear()
		done_button.visible = false
