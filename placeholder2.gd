extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _ready():
	$CanvasLayer/ViewportContainer/Viewport/Camera2D.camera = $Camera2D
