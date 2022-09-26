extends LevelObject

var object_path = "res://level/objects/moving_platform"
var path
var path_follow
var curve
var line

var platform
var editor_hitbox

var moving
var ready := true
var direction := 1

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
	if properties.move_type != 1:
		path_follow.loop = false
	path.add_child(path_follow)
	
	platform = Node2D.new()
	if properties.platform_type == 0:
		platform.set_script(preload("res://level/objects/platform/platform.gd"))
		platform.current_mode = 1
		platform.load_properties({
			"properties": {
				"width": properties.width,
				"texture": properties.texture,
			},
			"base_properties": {},
			"type_id": 1
		})
	elif properties.platform_type == 1:
		platform.set_script(preload("res://level/objects/block/block.gd"))
		platform.current_mode = 1
		platform.load_properties({
			"properties": {},
			"base_properties": {},
			"type_id": 6
		})
	platform.load_object()
	add_child(platform)
	
	if properties.platform_type == 0:
		platform.player_detector.connect("body_entered", self, "player_collided")
	
	if current_mode == 1:
		editor_hitbox = platform.get_node("Editor")
		platform.remove_child(editor_hitbox)
		add_child(editor_hitbox)

	loaded = true
	return self

func player_collided(body):
	if !body.grounded || !ready: return
	moving = true
	ready = false

func _physics_process(delta):
	# match statement REFUSED to work for some reason
	if properties.move_type == 1:
		path_follow.offset += properties.speed
	elif properties.move_type == 2:
		if moving:
			path_follow.offset += properties.speed
		if path_follow.unit_offset == 1:
			moving = false
			platform.modulate.a = lerp(platform.modulate.a, 0, delta * 6)
			if platform.modulate.a <= 0.05:
				path_follow.unit_offset = 0
				ready = true
		if ready || moving:
			platform.modulate.a = lerp(platform.modulate.a, 1, delta * 6)
	elif properties.move_type == 3:
		path_follow.offset += properties.speed * direction
		if (path_follow.unit_offset == 1 && direction == 1) || (path_follow.unit_offset == 0 && direction == -1):
			direction = -direction
			
	platform.position = path_follow.position
	if current_mode == 1:
		editor_hitbox.position = platform.position
