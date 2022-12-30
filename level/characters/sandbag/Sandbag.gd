extends Character

export var can_move := true
export var friction : float

func _physics_process(delta):
	if !can_move: return
	process_collisions(delta)
	process_gravity(delta)
	apply_velocity(delta)
	velocity.x = lerp(velocity.x, 0, delta * friction)
