extends Control

onready var anim_player = $AnimationPlayer

export var cooldown_time := 0.0
var cooldown : float
var open : bool

func _ready():
	Globals.level.connect("sign_opened", self, "open")

func open(text):
	if cooldown > 0: return
	cooldown = cooldown_time
	$Dialogue.text = text
	open = true
	anim_player.play("open")

func close():
	if cooldown > 0: return
	cooldown = cooldown_time
	anim_player.play("close")
	open = false

func _physics_process(delta):
	if cooldown <= 0: return
	cooldown -= delta

func _input(event):
	if cooldown > 0: return
	if event.is_action_pressed("attack") && open:
		get_tree().paused = false
		close()
