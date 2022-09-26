extends LevelObject

var object_path = "res://level/objects/moving_platform"
var path
var path_follow
var curve
var line

var platform

func _init():
	list_path = object_path + "/PropertyList.tres"

# functions
func load_object():	
	path = Path2D.new()
	add_child(path)
	curve = Curve2D.new()
	for point in properties.points:
		curve.add_point(point)
	path.curve = curve
	
	line = Line2D.new()
	line.points = curve.get_baked_points()
	line.texture = load(object_path + "/dotted.png")
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.width = 2
	line.default_color = Color.white
	line.default_color.a = 0.8
	line.z_index = -4
	add_child(line)
	
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	
	platform = Node2D.new()
	platform.set_script(load("res://level/objects/platform/platform.gd"))
	platform.current_mode = 2
	platform.load_properties({
		"properties": {
			"width": properties.width,
			"texture": properties.texture,
		},
		"base_properties": {},
		"type_id": 1
	})
	platform.load_object()
	add_child(platform)

	loaded = true
	return self

func _physics_process(delta):
	path_follow.offset += 2
	platform.position = path_follow.position
	platform.body.position = Vector2() # hacky bugfix
