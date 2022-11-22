extends GridContainer

onready var editor = get_tree().get_current_scene()

var buttons = []
var items = []

func _ready():
	var index = 0
	for button in get_children():
		buttons.append(button)
		button.connect("pressed", self, "pick_item", [index])
		index += 1
	
	index = 0
	var terrain_list = load("res://level/editor/items/Terrain.tres")
	for item_name in terrain_list.ids:
		if index < 6:
			var item = load("res://level/editor/items/terrain/" + item_name + ".tres")
			items.append(item)
			index += 1
		else:
			break
	
	editor.connect("ready", self, "pick_item", [0])
	update_buttons()

func add_item(item):
	if !items.has(item):
		items.pop_front()
		items.append(item)
		update_buttons()

func pick_item(index, item = null):
	if item != null:
		index = items.find(item)
	editor.pick_item(items[index])

func update_buttons():
	var index = 0
	for button in buttons:
		button.texture_normal = items[index].icon
		index += 1
