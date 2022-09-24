extends PathFollow2D

export var move : NodePath
onready var move_node = get_node(move)
export var speed : float

var reverse = false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	unit_offset = (unit_offset + (speed * delta * 0.1  * (1 if !reverse else -1)))
	if !reverse && unit_offset >= 1:
		reverse = true
	elif reverse && unit_offset <= 0:
		reverse = false
	
	move_node.global_position = global_position
