extends Node

export var code = ""
export var level_path = ""
export var exit_to = "res://level/LevelEditor.tscn"
onready var control = Control.new()

var muted
var level

func _init():
	pause_mode = PAUSE_MODE_PROCESS

func _ready():
	add_child(control)

func _unhandled_input(event):
	if event.is_action_pressed("mute_music"):
		muted = !muted
		AudioServer.set_bus_mute(1, muted)
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
