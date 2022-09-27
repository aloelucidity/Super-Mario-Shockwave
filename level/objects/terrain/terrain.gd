extends LevelObject

var object_path = "res://level/objects/terrain"
var terrain 
var collision
var body

var editor_area
var editor_collision

func _init():
	list_path = object_path + "/PropertyList.tres"

# functions
func load_object():
	create_terrain()
	if current_mode == 1:
		create_editor()
	
	loaded = true
	return self

func create_terrain():
	terrain = SS2D_Shape_Closed.new()
	collision = CollisionPolygon2D.new()
	body = KinematicBody2D.new()
	
	var texture_map = preload("res://level/objects/terrain/textures/IDMap.tres")
	var texture_key = texture_map.ids[properties.texture_id]
	
	terrain.shape_material = load(object_path + "/textures/" + texture_key + "/tileset.tres")
	terrain.z_index = 2
	terrain.add_points(properties.points)
	body.add_child(terrain)
	body.add_child(collision)
	add_child(body)
	
	terrain.collision_polygon_node_path = terrain.get_path_to(collision)
	terrain.bake_collision()

func create_editor():
	editor_area = Area2D.new()
	editor_area.set_collision_layer_bit(0, false)
	editor_area.set_collision_layer_bit(19, true)
	editor_area.set_collision_mask_bit(0, false)
	add_child(editor_area)
	
	editor_collision = CollisionPolygon2D.new()
	editor_collision.polygon = collision.polygon
	editor_area.add_child(editor_collision)
	
	if !properties.solid:
		collision.call_deferred("queue_free")
