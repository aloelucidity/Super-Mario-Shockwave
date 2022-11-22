tool
extends Sprite

export var start_rot : int
export var speed : float

func _ready():
	rotation_degrees = start_rot

func _physics_process(delta):
	rotation_degrees += speed
