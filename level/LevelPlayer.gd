extends Node2D

onready var level = $Level
export var code = ""

var player
var camera
var background
var hud

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
	
	for i in range(Multi.player_ids.size() + 1):
		var player = spawn_player()
	spawn_camera()
	load_background(camera)
	load_hud()
	# temp
	add_child(preload("res://Globals.tscn").instance())
	load_music(level)
	#

func _unhandled_input(event):
	if event.is_action_pressed("test_level") && !Input.is_action_pressed("fullscreen"):
		var _a = get_tree().change_scene_to(load("res://level/LevelEditor.tscn"))

func load_music(level):
	get_node("Globals").volume = level.get_area(0).music_volume
	get_node("Globals").load_song(level.get_area(0).music_id)

func load_background(_camera):
	background = preload("res://level/backgrounds/Background.tscn").instance()
	background.load_background(camera, level)
	add_child(background)

func load_hud():
	hud = preload("res://level/hud/HUD.tscn").instance()
	add_child(hud)

func spawn_player():
	player = preload("res://level/characters/player/Player.tscn").instance()
	add_child(player)
	return player

func spawn_camera():
	camera = preload("res://level/camera/camera.tscn").instance()
	add_child(camera)
	camera.follow_path = camera.get_path_to(player)
