extends VBoxContainer

var open : bool

func toggle(pressed):
	open = pressed

func _physics_process(delta):
	rect_scale.y = lerp(rect_scale.y, 1 if open else 0, delta * 10)
	visible = false if rect_scale.y < 0.01 else true
