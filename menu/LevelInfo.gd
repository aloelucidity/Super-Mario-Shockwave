extends Control

var code : String
var level_path : String
var level_info

onready var thumbnail = $Thumbnail
onready var level_name = $VBoxContainer/LevelName
onready var level_author = $VBoxContainer/LevelAuthor
onready var description = $Description

func load_level(_code : String, _level_path : String):
	if _code == "": return
	code = _code
	level_path = _level_path
	level_info = LevelCode.get_lvl_info(code)
	
	level_name.text = level_info.level_name
	level_author.text = "Author: " + level_info.level_author
	description.text = level_info.level_description
	if level_info.thumbnail_url.begins_with("res://"):
		thumbnail.texture = load(level_info.thumbnail_url)
	else:
		thumbnail.texture = preload("res://menu/assets/white.png")

func play_level():
	Globals.code = code
	Globals.level_path = level_path
	Globals.exit_to = "res://menu/LevelStudio.tscn"
	var _scene = get_tree().change_scene_to(preload("res://level/LevelPlayer.tscn"))

func edit_level():
	Globals.code = code
	Globals.level_path = level_path
	var _scene = get_tree().change_scene_to(preload("res://level/LevelEditor.tscn"))

func copy_code():
	OS.clipboard = code

func delete_level():
	var dir = Directory.new()
	dir.remove(level_path)
	get_parent().go_back()
