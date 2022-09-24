extends Node
class_name State

var character

export var priority : int
export(Array, String) var blacklisted_states = []

export var animation : String
export var autoflip : bool
export var override_rotation : bool
export var disable_movement : bool
export var disable_snap : bool
export var speed_scale : float = 1
export var gravity_multiplier : float = 1

func _ready():
	character = get_node("../../")

func handle_update(delta: float):
	if character.controllable:
		if character.state != self and _start_check(delta):
			var old_priority = -1 if character.state == null else character.state.priority
			if self.priority >= old_priority and !is_in_blacklisted_state():
				character.set_state(self, delta)
		if character.state == self:
			_update(delta)
		if character.state == self and _stop_check(delta):
			character.set_state(null, delta)
	_general_update(delta)

func is_in_blacklisted_state():
	var blacklisted = false
	for state_name in blacklisted_states:
		if character.state == character.get_state_node(state_name) and character.state != null:
			blacklisted = true
	return blacklisted

func _start_check(_delta: float):
	pass
	
func _start(_delta: float):
	pass
	
# called every frame only when the state is active
func _update(_delta: float):
	pass
	
func _stop_check(_delta: float):
	pass
	
func _stop(_delta: float):
	pass
	
# called every frame regardless of if the state is active
func _general_update(_delta: float):
	pass
