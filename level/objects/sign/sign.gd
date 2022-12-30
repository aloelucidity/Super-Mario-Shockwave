extends LevelObject

var player

var sprite
var alpha : float

var read_range
var in_range : bool
var active : bool

var cooldown : float

func _init():
	object_path = "res://level/objects/sign"
	list_path = object_path + "/PropertyList.tres"

# functions
func load_object():
	var scene = load(object_path + "/sign.tscn").instance()
	add_child(scene)
	
	var hitbox = scene.get_node("EditorHitbox")
	if current_mode == 1:
		scene.remove_child(hitbox)
		add_child(hitbox)
	else:
		hitbox.queue_free()
	
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
	if cooldown > 0:
		cooldown -= delta
	if !loaded: return
	active = in_range
	if active and !player.grounded:
		active = false
	
	var target = 0.2 if active else 0
	alpha = lerp(alpha, target, delta * 3)
	
	var color = Color.white
	color.a = alpha
	
	sprite.material.set_shader_param("outline_color", color)

func _input(event):
	if event.is_action_pressed("attack") and active and cooldown <= 0 and player.movement.direction == 0:
		cooldown = 1
		
		var cur_scene = get_tree().get_current_scene()
		cur_scene.hud.get_node("Sign").open(properties.text)
		get_tree().paused = true

func properties_ui_path():
	return object_path + "/PropertyUI.tres"
