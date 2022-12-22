extends Sprite

export var speed := 0.0

onready var rot = rotation_degrees

func _physics_process(_delta):
	rot += speed
	rotation_degrees = rot
