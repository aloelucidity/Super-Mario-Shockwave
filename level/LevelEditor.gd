extends Node2D

onready var level = $Level
onready var camera = $Camera2D
onready var placement = $Placement
var zoom = Vector2(1, 1)

export var code = ""
var selected_object
var is_ui

# temp
var placement_tool = "res://level/placement/Terrain.gd"
onready var id_map = preload("res://level/objects/IDMap.tres")
#

func _init():
	seed(0)

func _ready():
	code = Globals.code
	if code == "":
		var file = File.new()
		file.open("res://level/default_level.tres", file.READ)
		code = file.get_as_text()
	
	var decode = LevelCode.decode_level(code)
	level.load_level(decode)

func load_level():
	Globals.code = OS.clipboard
	var _scene = get_tree().reload_current_scene()

func save_level():
	var encode = LevelCode.encode_level(level.save_level())
	OS.clipboard = encode

func test_level():
	Globals.code = LevelCode.encode_level(level.save_level())
	var _scene = get_tree().change_scene_to(preload("res://level/LevelPlayer.tscn"))

func _input(event):
	if event.is_action_pressed("click") && !is_instance_valid(selected_object) && !is_ui:
		placement.click(get_global_mouse_position())
	if event.is_action_pressed("r_click") && is_instance_valid(selected_object) && !is_ui:
		level.get_area(level.persistent_data.current_area).delete_object(selected_object, true)

func _unhandled_input(event):
	if event.is_action_pressed("save_level"):
		save_level()
	if event.is_action_pressed("load_level"):
		load_level()
	if event.is_action_pressed("test_level"):
		test_level()

func deselect_object(_object):
	if !is_instance_valid(selected_object): return
	selected_object.modulate.a = 1
	selected_object = null

func select_object(object):
	selected_object = object
	selected_object.modulate.a = 0.5

func cursor_entered(area):
	deselect_object(area.get_parent())
	select_object(area.get_parent())

func cursor_exited(area):
	if selected_object == area.get_parent():
		deselect_object(area.get_parent())

func change_placement():
	placement.queue_free()
	var new_placement = Node2D.new()
	new_placement.name = "Placement"
	new_placement.set_script(load(placement_tool))
	add_child(new_placement)
	placement = new_placement
	update_icon(0)

func safe_entered():
	is_ui = false

func safe_exited():
	is_ui = true

func update_icon(obj_id):
	if placement_tool == "res://level/placement/Terrain.gd":
		var texture_map = preload("res://level/objects/terrain/textures/IDMap.tres")
		var texture_key = texture_map.ids[placement.texture_id]
		$CanvasLayer/Icon.texture = load("res://level/objects/terrain/textures/" + texture_key + "/icon.png")
	elif placement_tool == "res://level/placement/Platform.gd":
		match(obj_id):
			0:
				$CanvasLayer/Icon.texture = load("res://level/objects/moving_platform/icon.png")
			1:
				$CanvasLayer/Icon.texture = load("res://level/objects/block/icon.png")
	else:
		var name = id_map.ids[obj_id]
		$CanvasLayer/Icon.texture = load("res://level/objects/" + name + "/icon.png")

func terrain_switch():
	placement_tool = "res://level/placement/Terrain.gd"
	change_placement()

func platform_switch():
	placement_tool = "res://level/placement/Platform.gd"
	change_placement()

func object_switch():
	placement_tool = "res://level/placement/Default.gd"
	change_placement()
