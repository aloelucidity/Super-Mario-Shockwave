extends Control

export var window_name : String

var mouse_over : bool
var rect_offset

func _enter_tree():
	$Label.text = window_name

func open():
	visible = true
	rect_position = Vector2(24, 78)

func close():
	visible = false

func mouse_entered():
	mouse_over = true

func mouse_exited():
	mouse_over = false

func _input(event):
	if event.is_action_pressed("click") && mouse_over:
		var mouse_pos = get_viewport().get_mouse_position()
		rect_offset = rect_position - mouse_pos
	if event is InputEventMouseMotion && Input.is_action_pressed("click") && mouse_over:
		rect_position = event.position + rect_offset 
