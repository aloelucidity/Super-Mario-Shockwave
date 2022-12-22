extends Character
class_name Player

var camera = null
var frozen := false
onready var animations = $Animations
onready var health = $Health

func _physics_process(delta):
	if frozen: return
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
