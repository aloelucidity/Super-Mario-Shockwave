extends LevelObject

# functions
func load_object():
	var scene = preload("res://level/objects/star/star.tscn").instance()
	add_child(scene)
	
	var hitbox = scene.get_node("EditorHitbox")
	scene.remove_child(hitbox)
	add_child(hitbox)
	
	loaded = true
	return self
