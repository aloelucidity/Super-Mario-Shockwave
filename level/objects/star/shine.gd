extends Sprite

export var speed := 0.0
export var step := 0

onready var rot = rotation_degrees

func _physics_process(delta):
	rot += speed
	rotation_degrees = stepify(rot, step)
