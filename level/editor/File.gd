extends VBoxContainer

var open : bool
onready var file = File.new()
var encode : String

export var button_path : NodePath
onready var button = get_node(button_path)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		toggle(false)

func toggle(pressed):
	open = pressed
	button.pressed = pressed
	
	if pressed:
		encode = LevelCode.encode_level(Globals.level.save_level())
		file.open(Globals.level_path, File.READ)
		$Code.disabled = (encode == file.get_as_text())
		file.close()

func save_level():
	encode = LevelCode.encode_level(Globals.level.save_level())
	file.open(Globals.level_path, File.WRITE)
	file.store_string(encode)
	file.close()
	toggle(false)

func _physics_process(delta):
	rect_scale.y = lerp(rect_scale.y, 1 if open else 0, delta * 10)
	visible = false if rect_scale.y < 0.01 else true
