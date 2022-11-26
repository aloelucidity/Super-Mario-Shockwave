extends LevelObject

func _init():
	object_path = "res://level/objects/saw"

# functions
func load_object():
	var scene = load(object_path + "/saw.tscn").instance()
	add_child(scene)
	
	var hitbox = scene.get_node("EditorHitbox")
	scene.remove_child(hitbox)
	add_child(hitbox)

	loaded = true
	return self
