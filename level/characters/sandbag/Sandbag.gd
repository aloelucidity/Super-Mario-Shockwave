extends Character

export var friction : float

func _physics_process(delta):
	process_collisions(delta)
	process_gravity(delta)
	apply_velocity(delta)
	velocity.x = lerp(velocity.x, 0, delta * friction)
