extends Control

var current_list
var open : bool
var items = []

func _physics_process(delta):
	rect_position.x = lerp(rect_position.x, 420 if open else 516, delta * 6)

func open_tab(tab : String):
	for child in $ScrollContainer/GridContainer.get_children():
		child.queue_free()
	items.clear()
	
	current_list = load("res://level/editor/items/" + tab + ".tres")
	var index = 0
	for item_name in current_list.ids:
		var item = load("res://level/editor/items/" + tab.to_lower() + "/" + item_name + ".tres")
		items.append(item)
		var button = preload("res://level/editor/properties/square_button.tscn").instance()
		button.get_node("Sprite").texture = item.icon
		button.name = item.name
		$ScrollContainer/GridContainer.add_child(button)
		button.connect("mouse_entered", self, "update_info", [index])
		index += 1

func update_info(id):
	$Label.text = items[id].name
	$Icon.texture = items[id].icon

func item_clicked():
	pass
