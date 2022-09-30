extends Node

export var code = ""

var muted

func _unhandled_input(event):
	if event.is_action_pressed("mute_music"):
		muted = !muted
		AudioServer.set_bus_mute(1, muted)
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
