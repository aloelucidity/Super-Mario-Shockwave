extends LevelObject

var sprite
var body
var collision

var player_detector
var player_collision

var editor_body
var editor_collision
var part_width : int

func _init():
	object_path = "res://level/objects/platform"
	list_path = object_path + "/PropertyList.tres"

# functions
func load_object():	
	# collision
	body = KinematicBody2D.new()
	#body.set_sync_to_physics(true)
	add_child(body)
	
	collision = CollisionShape2D.new()
	collision.one_way_collision = true
	collision.shape = RectangleShape2D.new()
	collision.position.y = -4
	body.add_child(collision)
	
	# visuals
	sprite = NinePatchRect.new()
	match(properties.texture):
		0:
			sprite.texture = load(object_path + "/wood.png")
			sprite.axis_stretch_horizontal = sprite.AXIS_STRETCH_MODE_TILE
			sprite.patch_margin_left = 16
			sprite.patch_margin_right = 16
			sprite.rect_size.y = 13
			part_width = 8
		1:
			sprite.texture = load(object_path + "/moving.png")
			sprite.axis_stretch_horizontal = sprite.AXIS_STRETCH_MODE_TILE
			sprite.patch_margin_left = 7
			sprite.patch_margin_right = 7
			sprite.rect_size.y = 16
			part_width = 8
	
	add_child(sprite)
	
	player_detector = Area2D.new()
	player_detector.set_collision_layer_bit(0, false)
	player_detector.set_collision_mask_bit(1, true)
	player_detector.set_collision_mask_bit(0, false)
	add_child(player_detector)
	player_collision = CollisionShape2D.new()
	player_collision.shape = RectangleShape2D.new()
	player_collision.shape.extents.y = 2
	player_collision.position.y = -6
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
		editor_collision.position.y = -1
		editor_body.add_child(editor_collision)
	
	rotation_degrees = properties.rotation
	width_changed()
	loaded = true
	return self

# properties
func set_property(key : String, new_value):
	properties[key] = new_value
	match(key):
		"width":
			width_changed()

# other
func width_changed():
	sprite.rect_size.x = sprite.patch_margin_left + sprite.patch_margin_right + (properties.width * part_width)
	sprite.rect_position = -sprite.rect_size / 2
	collision.shape.extents = Vector2(sprite.rect_size.x / 2, 1)
	player_collision.shape.extents.x = sprite.rect_size.x / 2
	if current_mode == 1:
		editor_collision.shape.extents = Vector2(sprite.rect_size.x / 2, 5)

func properties_ui_path():
	return object_path + "/PropertyUI.tres"
