extends LevelObject

func _init():
	object_path = "res://level/objects/saw"

# functions
func load_object():
	var scene = load(object_path + "/saw.tscn").instance()
	add_child(scene)

	loaded = true
	return self
