extends CanvasLayer

var viewport

var bg_map
var fg_map
export var bg_id = 0
export var fg_id = 0

func load_background(camera : Node = null, level : Level = null):
	bg_id = level.get_area(level.persistent_data.current_area).background_id
	fg_id = level.get_area(level.persistent_data.current_area).foreground_id
	
	bg_map = preload("res://level/backgrounds/background/IDMap.tres")
	fg_map = preload("res://level/backgrounds/foreground/IDMap.tres")
	viewport = $ViewportContainer/Viewport
	
	var bg_key = bg_map.ids[bg_id]
	var bg = load("res://level/backgrounds/background/" + bg_key + "/" + bg_key + ".tscn").instance()
	var bg_fx = load("res://level/backgrounds/background/" + bg_key + "/filters.tres")
	viewport.add_child(bg)
	
	var fg_key = fg_map.ids[fg_id]
	var fg = load("res://level/backgrounds/foreground/" + fg_key + "/" + fg_key + ".tscn").instance()
	for child in fg.get_children():
		child.modulate = bg_fx.fg_tint
	if bg_fx.shader_material != null:
		$CanvasLayer/ColorRect.material = bg_fx.shader_material
	else:
		$CanvasLayer/ColorRect.queue_free()
	
	viewport.add_child(fg)
	
	if is_instance_valid(camera):
		$ViewportContainer/Viewport/Camera2D.camera = camera
