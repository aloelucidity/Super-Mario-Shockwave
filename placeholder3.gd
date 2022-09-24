extends KinematicBody2D

export var speed : float

func _physics_process(delta):
	rotation_degrees += speed * delta
