class_name input_util

static func get_vector(right : String, left : String, down : String, up : String):
	return Vector2(Input.get_action_strength(right) - Input.get_action_strength(left),
			Input.get_action_strength(down) - Input.get_action_strength(up)).limit_length(1)
