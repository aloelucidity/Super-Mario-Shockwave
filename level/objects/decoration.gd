extends LevelObject
class_name Decoration

var object_path = "res://level/objects/coin"
var frames = 1

var editor_area
var editor_collision

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
		editor_area.set_collision_layer_bit(1, false)
		editor_area.set_collision_layer_bit(19, true)
		editor_area.set_collision_mask_bit(1, false)
		add_child(editor_area)
		
		editor_collision = CollisionShape2D.new()
		editor_collision.shape = CircleShape2D.new()
		editor_collision.shape.radius = 8
		editor_collision.position.y = -1
		editor_area.add_child(editor_collision)
	
	loaded = true
	return self
