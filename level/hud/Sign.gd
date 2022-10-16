extends Control

onready var anim_player = $AnimationPlayer

export var cooldown_time := 0.0
var cooldown : float

func open(text):
	if cooldown > 0: return
	cooldown = cooldown_time
	$Dialogue.text = text
	anim_player.play("open")

func close():
	if cooldown > 0: return
	cooldown = cooldown_time
	anim_player.play("close")

func _physics_process(delta):
	if cooldown <= 0: return
	cooldown -= delta
