extends LevelObject

var sprite
var body
var collision

var player_detector
var player_collision

var editor_body
var editor_collision

var rotation_countdown := 0.0
var rotating : bool
var current_step := 0

func _init():
	object_path = "res://level/objects/block"
	list_path = object_path + "/PropertyList.tres"

func _physics_process(delta):
	if !rotating:
		rotation_countdown -= delta
		if rotation_countdown <= 0.5:
			rotation_degrees = current_step + rand_range(-2, 2)
		if rotation_countdown <= 0:
			rotating = true
			rotation_degrees = stepify(rotation_degrees, 90)
	else:
		rotation_degrees += 2
		if wrapf(rotation_degrees, 0, 90) < 2:
			rotation_degrees = stepify(rotation_degrees, 90)
			rotation_degrees = wrapf(rotation_degrees, 0, 360)
			current_step = rotation_degrees
			rotation_countdown = properties.rotation_interval
			rotating = false

# functions
func load_object():	
	# collision
	body = KinematicBody2D.new()
	#body.set_sync_to_physics(true)
	add_child(body)
	
	collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.extents = Vector2(32, 32)
	body.add_child(collision)
	
	# visuals
	sprite = Sprite.new()
	sprite.texture = load(object_path + "/moving.png")
	add_child(sprite)
	
	player_detector = Area2D.new()
	player_detector.set_collision_layer_bit(0, false)
	player_detector.set_collision_mask_bit(1, true)
	player_detector.set_collision_mask_bit(0, false)
	add_child(player_detector)
	player_collision = CollisionShape2D.new()
	player_collision.shape = RectangleShape2D.new()
	player_collision.shape.extents = Vector2(34, 34)
	player_detector.add_child(player_collision)
	
	# editor
	if current_mode == 1:
		editor_body = Area2D.new()
		editor_body.name = "Editor"
		editor_body.set_collision_layer_bit(0, false)
		editor_body.set_collision_layer_bit(19, true)
		editor_body.set_collision_mask_bit(0, false)
		add_child(editor_body)
		
		editor_collision = CollisionShape2D.new()
		editor_collision.one_way_collision = true
		editor_collision.shape = RectangleShape2D.new()
		editor_collision.shape.extents = Vector2(32, 32)
		editor_body.add_child(editor_collision)

	rotation_countdown = properties.rotation_interval
	loaded = true
	return self
