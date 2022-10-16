extends Area2D

onready var player = get_parent()
export var strength : float

var check_countdown : float

func area_entered(area):
	if area.get_collision_layer_bit(1) == false: return
	var direction = (global_position - area.global_position).normalized()
	player.velocity = direction * strength

func _physics_process(delta):
	check_countdown -= delta
	if check_countdown <= 0:
		check_countdown = 0.5
		if get_overlapping_areas().size() > 0:
			for area in get_overlapping_areas():
				area_entered(area)
