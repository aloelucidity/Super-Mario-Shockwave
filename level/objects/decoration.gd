extends LevelObject
class_name Decoration

var object_path = "res://level/objects/coin"
var frames = 1

var editor_area
var editor_collision

var editor_extents := Vector2(8, 8)
var editor_offset := Vector2()

# functions
func load_object():
	z_index = -2
	
	var sprite = Sprite.new()
	sprite.texture = load(object_path + "/texture.png")
	sprite.hframes = frames
	sprite.frame = rand_range(0, frames) # replace this with a property later pls
	sprite.flip_h = bool(randi() & 1) # this too
	add_child(sprite)

	# editor
	if current_mode == 1:
		editor_area = Area2D.new()
		editor_area.set_collision_layer_bit(0, false)
		editor_area.set_collision_layer_bit(19, true)
		editor_area.set_collision_mask_bit(0, false)
		add_child(editor_area)
		
		editor_collision = CollisionShape2D.new()
		editor_collision.shape = RectangleShape2D.new()
		editor_collision.shape.extents = editor_extents
		editor_collision.position = editor_offset
		editor_area.add_child(editor_collision)
	
	loaded = true
	return self
