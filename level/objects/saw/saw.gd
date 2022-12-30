extends LevelObject

func _init():
	object_path = "res://level/objects/saw"

# functions
func load_object():
	var scene = load(object_path + "/saw.tscn").instance()
	add_child(scene)
	
	var hitbox = scene.get_node("EditorHitbox")
	if current_mode == 1:
		scene.remove_child(hitbox)
		add_child(hitbox)
	else:
		hitbox.queue_free()

	loaded = true
	return self
