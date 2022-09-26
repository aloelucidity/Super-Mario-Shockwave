extends Control

export var target_path : NodePath
var target

export var prefix : String
export var value : String
export var increment : int = 1
export var min_val : int
export var max_val : int

func _ready():
	for _i in range(5):
		yield(get_tree(), "idle_frame")
	target = get_node(target_path).get_area(0)
	update_label()

func increase():
	target[value] += increment
	update_label()

func decrease():
	target[value] -= increment
	update_label()

func update_label():
	target[value] = wrapi(target[value], min_val, max_val)
	$Label.text = prefix + str(target[value])
