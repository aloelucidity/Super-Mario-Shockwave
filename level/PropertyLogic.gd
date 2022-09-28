extends ScrollContainer

func load_object(object : LevelObject):
	for child in $Control.get_children():
		child.queue_free()
	for property in load(object.object_path + "/PropertyUI.tres").properties:
		var ui_scene = load("res://level/editor/properties/" + property[0] + ".tscn").instance()
		$Control.add_child(ui_scene)
		ui_scene.load_property(object, property[1], property[2], property[3])
	
	$Control.add_child(Control.new())