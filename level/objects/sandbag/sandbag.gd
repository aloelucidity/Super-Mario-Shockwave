extends LevelObject

# functions
func load_object():
	var scene = preload("res://level/characters/sandbag/Sandbag.tscn").instance()
	add_child(scene)
	
	loaded = true
	return self
