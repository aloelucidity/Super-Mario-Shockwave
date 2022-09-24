extends Character
class_name Player

var camera = null
onready var animations = $Animations

func _physics_process(delta):
	process_inputs()
	process_collisions(delta)
	update_states(delta)
	$Movement.update(delta)
	process_gravity(delta)
	$Animations.update(delta)
	
	apply_velocity(delta)

func shake_camera(intensity, time):
	if is_instance_valid(camera):
		camera.shake_intensity = intensity
		camera.shake_time = time
