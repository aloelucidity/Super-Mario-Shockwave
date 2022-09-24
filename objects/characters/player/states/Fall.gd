extends State

func is_bump(delta):
	if character.velocity.y < 0:
		return character.test_move(character.get_transform(), Vector2(0, character.velocity.y * delta))
	else:
		return false

func _start_check(delta):
	return !character.grounded

func _stop_check(_delta):
	return character.grounded

func _stop(_delta):
	animation = "fall"

func _general_update(delta):
	if is_bump(delta):
		character.velocity.y = 5
