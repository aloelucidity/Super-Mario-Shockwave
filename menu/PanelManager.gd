extends Panel

onready var animation_player = $AnimationPlayer
onready var level_info = $LevelInfo
onready var grid_container = $Levels/GridContainer

export var starting_path : NodePath
onready var starting_panel = get_node(starting_path)
onready var current_panel = starting_panel

var transitioning : bool
var buttons = []

func go_back():
	if current_panel.name != starting_panel.name:
		open_panel(starting_panel)
	else:
		get_tree().get_current_scene().go_back()

func open_level(code : String, level_path : String):
	level_info.load_level(code, level_path)
	open_panel(level_info)

func open_panel_by_path(path : NodePath):
	open_panel(get_node(path))

func open_panel(new_panel):
	if transitioning: return
	if new_panel != current_panel:
		transitioning = true
		
		animation_player.play("close_" + current_panel.name)
		yield(animation_player, "animation_finished")
		animation_player.play("open_" + new_panel.name)
		current_panel = new_panel
		
		transitioning = false
		
		if new_panel.name == "Levels":
			load_levels()

func load_levels():
	var button = preload("res://menu/Level.tscn")
	for child in grid_container.get_children():
		child.queue_free()
	
	var create_new = button.instance()
	create_new.get_node("Label").text = "Create new..."
	create_new.connect("pressed", self, "open_panel_by_path", ["CreateLevel"])
	grid_container.add_child(create_new)
	
	var file = File.new()
	var dir = Directory.new()
	if !dir.dir_exists("user://saved_levels"):
		dir.make_dir("user://saved_levels")
	dir.open("user://saved_levels")
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			var file_path = dir.get_current_dir() + "/" + file_name
			file.open(file_path, File.READ)
			
			var level = button.instance()
			level.code = file.get_as_text()
			level.connect("pressed", self, "open_level", [level.code, file_path])
			buttons.append([file.get_modified_time(file_path), level])
			
			file.close()
		file_name = dir.get_next()
	
	buttons.sort_custom(self, "sort_levels")
	for level in buttons:
		grid_container.add_child(level[1])

func sort_levels(a, b):
	if a[0] > b[0]:
		return true
	return false
