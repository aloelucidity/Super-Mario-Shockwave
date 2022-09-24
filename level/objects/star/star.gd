extends LevelObject

# functions
func load_object():
	var scene = preload("res://level/objects/star/star.tscn").instance()
	add_child(scene)
	
	var hitbox = get_node("Star/EditorHitbox")
	$Star.remove_child(hitbox)
	add_child(hitbox)
	
	loaded = true
	return self
