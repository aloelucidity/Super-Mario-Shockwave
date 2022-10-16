extends LevelObject

var player

var sprite
var alpha : float

var read_range
var in_range : bool

func _init():
	object_path = "res://level/objects/sign"

# functions
func load_object():
	var scene = load(object_path + "/sign.tscn").instance()
	add_child(scene)
	
	var hitbox = scene.get_node("EditorHitbox")
	scene.remove_child(hitbox)
	add_child(hitbox)
	
	read_range = scene.get_node("ReadRange")
	read_range.connect("body_entered", self, "player_entered")
	read_range.connect("body_exited", self, "player_exited")
	sprite = scene.get_node("Sign")

	loaded = true
	return self

func player_entered(body):
	player = body
	in_range = true

func player_exited(body):
	player = null
	in_range = false

func _physics_process(delta):
	if !loaded: return
	var active = in_range
	if active and !player.grounded:
		active = false
	
	var target = 0.2 if active else 0
	alpha = lerp(alpha, target, delta * 3)
	
	var color = Color.white
	color.a = alpha
	
	sprite.material.set_shader_param("outline_color", color)