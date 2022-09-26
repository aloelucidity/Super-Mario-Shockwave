extends LevelObject

var object_path = "res://level/objects/coin"
var area
var collision

var editor_area
var editor_collision

# functions
func load_object():
	var sprite = Sprite.new()
	sprite.texture = load(object_path + "/animated.tres")
	add_child(sprite)
	
	area = Area2D.new()
	area.set_collision_layer_bit(0, false)
	area.set_collision_mask_bit(0, false)
	area.set_collision_mask_bit(1, true)
	area.connect("body_entered", self, "collect")
	add_child(area)
	
	collision = CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 16
	area.add_child(collision)

	# editor
	if current_mode == 1:
		editor_area = Area2D.new()
		editor_area.set_collision_layer_bit(0, false)
		editor_area.set_collision_layer_bit(19, true)
		editor_area.set_collision_mask_bit(0, false)
		add_child(editor_area)
		
		editor_collision = CollisionShape2D.new()
		editor_collision.shape = CircleShape2D.new()
		editor_collision.shape.radius = 8
		editor_collision.position.y = -1
		editor_area.add_child(editor_collision)
	
	loaded = true
	return self

func collect(_body):
	get_tree().get_current_scene().get_node("Globals/Coin").play()
	visible = false
	collision.call_deferred("set_disabled", true)
	area.call_deferred("set_collision_mask_bit", 1, false)
