extends State

export var punch_time : float
export var boost_power : Vector2

var attack_timer = 0.0
var end_timer = 0.0
var sprite

func _start_check(_delta):
	return attack_timer > 0

func _start(_delta):
	priority = 4
	attack_timer = 0
	disable_movement = true
	
	sprite = character.get_node("AnimatedSprite")
	end_timer = punch_time
	
	sprite.frame = 0
	character.velocity.x = boost_power.x * character.facing_direction
	character.velocity.y = -boost_power.y

func _update(delta):
	if end_timer > 0:
		end_timer -= delta
		if end_timer <= 0.5:
			disable_movement = false
		if end_timer <= 0:
			priority = 2

func _stop(_delta):
	priority = 4

func _stop_check(_delta):
	return character.grounded

func _general_update(delta):
	if end_timer > 0 && character.grounded:
		end_timer -= delta
		if end_timer <= 0:
			end_timer = 0
			
	if (character.inputs.move_up[0] 
		&& character.inputs.attack[1] 
		&& !character.grounded 
		&& (character.state == null || !character.state.name in blacklisted_states)
	):
		attack_timer = 0.2
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			attack_timer = 0
