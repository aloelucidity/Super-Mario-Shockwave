extends KinematicBody2D
class_name Character

export var states_path : NodePath
onready var states_node = get_node(states_path)

export var raycasts_path : NodePath
onready var raycasts_node = get_node(raycasts_path)

export(float) var gravity
export(float) var max_gravity
export(Dictionary) var inputs

var facing_direction : int = 1
var velocity : Vector2
var controllable : bool = true

# collisions
var grounded : bool
var ground_type : int

var last_state
var state

enum {GROUND}

func _ready():
	for key in inputs:
		inputs[key] = [false, false, false] # pressed, just pressed, just released

# by default this just takes the inputs from godot
# but you can override it for enemies and stuff
func process_inputs():
	for key in inputs:
		inputs[key][0] = Input.is_action_pressed(key)
		inputs[key][1] = Input.is_action_just_pressed(key)
		inputs[key][2] = Input.is_action_just_released(key)
		if !controllable:
			inputs[key][0] = false
			inputs[key][1] = false
			inputs[key][2] = false

func process_collisions(_delta):
	grounded = false
	for raycast in raycasts_node.get_children():
		if "Ground" in raycast.name:
			if raycast.is_colliding():
				grounded = true
				var contact_node = raycast.get_collider()
				if "ground_type" in contact_node:
					ground_type = contact_node.ground_type
				else:
					ground_type = 0

func gravity_multiplier():
	var multiplier = 1
	if is_instance_valid(state):
		multiplier *= state.gravity_multiplier
	return multiplier

func process_gravity(_delta):
	if velocity.y < max_gravity:
		velocity.y += gravity * gravity_multiplier()

func apply_velocity(_delta):
	var disable_snap = is_instance_valid(state) && state.disable_snap
	var snap = Vector2(0, 4) if !disable_snap else Vector2()
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)

func update_states(delta):
	for state_node in states_node.get_children():
		state_node.handle_update(delta)

func _physics_process(delta):
#	process_inputs()
#	process_collisions(delta)
#	update_states(delta)
#	process_gravity(delta)
#	apply_velocity(delta)
	pass

# states
func set_state(new_state: Node, delta: float) -> void:
	last_state = state
	state = null
	if is_instance_valid(last_state):
		last_state._stop(delta)
	if is_instance_valid(new_state):
		state = new_state
		new_state._start(delta)
	#emit_signal("state_changed", new_state, last_state)

func get_state_node(name: String) -> Node:
	if states_node.has_node(name):
		return states_node.get_node(name)
	return null

func set_state_by_name(name: String, delta: float = 0.0001) -> void:
	if is_instance_valid(get_state_node(name)):
		set_state(get_state_node(name), delta)
