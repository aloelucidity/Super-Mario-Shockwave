extends HBoxContainer

export var list_path : NodePath
onready var list = get_node(list_path)
var selected_button = null

func _ready():
	for child in get_children():
		child.connect("pressed", self, "button_pressed", [child])

func button_pressed(button):
	if selected_button == button:
		button.pressed = false
		selected_button = null
		list.open = false
	else:
		selected_button = button
		if selected_button.name == "File":
			list.open = false
		else:
			list.open = true
			list.open_tab(selected_button.name)
