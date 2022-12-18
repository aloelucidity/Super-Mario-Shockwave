extends LevelObject

var top
var top_start
var top_end
var label
var tele_y
var hinge

export var press_speed : float = 5
var character

var max_pounds : int = 3
var pounds_left : int = 3
var pound_cooldown : float

func body_entered(body):
	if is_instance_valid(character) : return
	if body.state == null || body.state.name != "GroundPound": return
	character = body
	pounds_left -= 1
	label.text = str(pounds_left)

func _physics_process(delta):
	if pound_cooldown > 0:
		pound_cooldown -= delta
		if pound_cooldown <= 0:
			pound_cooldown = 0
			top.set_collision_layer_bit(0, false)
			top.set_collision_layer_bit(5, true)
	var target_pos = top_end.position.y - (26 * (float(pounds_left) / max_pounds))
	top.position.y = lerp(top.position.y, target_pos, delta * press_speed)
	
	if abs(target_pos - top.position.y) < 2 && is_instance_valid(character):
		top.set_collision_layer_bit(0, true)
		top.set_collision_layer_bit(5, false)
		character = null
		pound_cooldown = 1

	if !is_instance_valid(character): return
	character.global_position.y = tele_y.global_position.y
	character.velocity.y = 0
	character.velocity.x = 0

func _init():
	object_path = "res://level/objects/trampoline"

# functions
func load_object():
	var scene = load(object_path + "/trampoline.tscn").instance()
	add_child(scene)
	
	var hitbox = scene.get_node("EditorHitbox")
	scene.remove_child(hitbox)
	add_child(hitbox)
	
	top = scene.get_node("Top")
	top_start = scene.get_node("TopStart")
	top_end = scene.get_node("TopEnd")
	label = scene.get_node("Top/Sprite/Label")
	tele_y = scene.get_node("Top/TeleY")
	hinge = scene.get_node("Hinge")
	
	var pound_area = scene.get_node("Top/PoundArea")
	pound_area.connect("body_entered", self, "body_entered")

	loaded = true
	return self
