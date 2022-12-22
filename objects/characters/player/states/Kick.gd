extends State

export var tele_amount : int
export var boost_power : Vector2

var attack_timer = 0.0
var sprite

func _start_check(_delta):
	return attack_timer > 0

func _start(_delta):
	character.grounded = false
	attack_timer = 0

	sprite = character.get_node("AnimatedSprite")
	sprite.frame = 0
	character.velocity.x = boost_power.x * -character.facing_direction
	character.velocity.y = -boost_power.y
	character.position.y -= tele_amount

func _stop_check(_delta):
	return character.grounded

func _general_update(delta):
	if (character.inputs.move_up[0] 
		&& character.inputs.attack[1] 
		&& character.grounded 
	):
		attack_timer = 0.2
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attack_timer = 0
