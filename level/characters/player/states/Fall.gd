extends State

export var max_squish_vel : float
var fall_vel

func is_bump(delta):
	if character.velocity.y < 0:
		return character.test_move(character.get_transform(), Vector2(0, character.velocity.y * delta))
	else:
		return false

func _start_check(delta):
	return !character.grounded

func _start(_delta):
	animation = "fall"
	fall_vel = 50

func _update(_delta):
	fall_vel = clamp(character.velocity.y, 0, max_squish_vel)

func _stop(_delta):
	if !character.grounded: return
	var sprite = character.get_node("AnimatedSprite")
	var squish_ratio = clamp(max_squish_vel - fall_vel, 0, max_squish_vel) / max_squish_vel
	squish_ratio = clamp(squish_ratio, 0, 1)
	sprite.offset.y = 10 * squish_ratio
	sprite.scale.y = 1 - (0.35 * squish_ratio)

func _stop_check(_delta):
	return character.grounded

func _general_update(delta):
	if is_bump(delta):
		character.velocity.y = 5
