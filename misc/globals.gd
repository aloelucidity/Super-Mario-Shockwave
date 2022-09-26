extends Node

export var code = ""

var muted

var coinCount : int
var healthCount = 3

func _unhandled_input(event):
	if event.is_action_pressed("mute_music"):
		muted = !muted
		AudioServer.set_bus_mute(1, muted)
