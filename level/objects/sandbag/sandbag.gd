extends LevelObject

# functions
func load_object():
	var scene = preload("res://level/characters/sandbag/Sandbag.tscn").instance()
	add_child(scene)
	
	var hitbox = scene.get_node("EditorHitbox")
	if current_mode == 1:
		scene.can_move = false
		scene.remove_child(hitbox)
		add_child(hitbox)
	else:
		hitbox.queue_free()
	
	loaded = true
	return self
