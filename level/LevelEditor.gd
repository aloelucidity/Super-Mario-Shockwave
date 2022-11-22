extends Node2D

onready var level = $Level
onready var camera = $Camera2D
onready var placement = $Placement
onready var properties = $CanvasLayer/Properties
onready var property_logic = $CanvasLayer/Properties/PropertyLogic
onready var code_window = $CanvasLayer/LevelCode
onready var code_handler = $CanvasLayer/LevelCode/CodeHandler
onready var settings_window = $CanvasLayer/LevelSettings
onready var backgrounds = $CanvasLayer/LevelSettings/Backgrounds
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
	Globals.level = level

func open_code():
	if !code_window.visible:
		code_window.open()
		code_handler.open(level)
	else:
		code_window.close()

func open_settings():
	if !settings_window.visible:
		settings_window.open()
		backgrounds.open(level)
	else:
		settings_window.close()

func test_level():
	Globals.code = LevelCode.encode_level(level.save_level())
	var _scene = get_tree().change_scene_to(preload("res://level/LevelPlayer.tscn"))

func quit():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("click") && !is_instance_valid(selected_object) && !is_ui:
		placement.click(get_global_mouse_position())
	elif event.is_action_pressed("click") && is_instance_valid(selected_object) && !is_ui:
		properties.open()
		property_logic.load_object(selected_object)
		
	if event.is_action_pressed("r_click") && is_instance_valid(selected_object) && !is_ui:
		level.get_area(level.persistent_data.current_area).delete_object(selected_object, true)

func _unhandled_input(event):
	if event.is_action_pressed("test_level") && !Input.is_action_pressed("fullscreen"):
		test_level()

func deselect_object():
	if !is_instance_valid(selected_object): return
	selected_object.modulate.a = 1
	selected_object = null

func select_object(object):
	if is_ui: return
	#if !$CanvasLayer/TopPanel/VBoxContainer/Select.pressed || is_ui: return
	selected_object = object
	selected_object.modulate.a = 0.5

func cursor_entered(area):
	deselect_object()
	select_object(area.get_parent())

func cursor_exited(area):
	if selected_object == area.get_parent():
		deselect_object()

func change_placement():
	placement.queue_free()
	var new_placement = Node2D.new()
	new_placement.name = "Placement"
	new_placement.z_index = 100
	new_placement.set_script(load(placement_tool))
	add_child(new_placement)
	placement = new_placement
	update_icon(0)

func safe_entered():
	is_ui = false

func safe_exited():
	is_ui = true
	deselect_object()

func update_icon(obj_id):
	if placement_tool == "res://level/placement/Terrain.gd":
		var texture_map = preload("res://level/objects/terrain/textures/IDMap.tres")
		var texture_key = texture_map.ids[placement.texture_id]
		$CanvasLayer/Icon.texture = load("res://level/objects/terrain/textures/" + texture_key + "/icon.png")
		if placement.is_bg:
			$CanvasLayer/Icon.self_modulate = Color.darkgray
		else:
			$CanvasLayer/Icon.self_modulate = Color.white
	elif placement_tool == "res://level/placement/Platform.gd":
		$CanvasLayer/Icon.self_modulate = Color.white
		match(obj_id):
			0:
				$CanvasLayer/Icon.texture = load("res://level/objects/moving_platform/icon.png")
			1:
				$CanvasLayer/Icon.texture = load("res://level/objects/block/icon.png")
	else:
		var name = id_map.ids[obj_id]
		$CanvasLayer/Icon.texture = load("res://level/objects/" + name + "/icon.png")
		$CanvasLayer/Icon.self_modulate = Color.white

func terrain_switch():
	placement_tool = "res://level/placement/Terrain.gd"
	change_placement()

func platform_switch():
	placement_tool = "res://level/placement/Platform.gd"
	change_placement()

func object_switch():
	placement_tool = "res://level/placement/Default.gd"
	change_placement()
