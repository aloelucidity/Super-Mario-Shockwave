extends Node

var player_ids = []
var players_ready = []
var net_id

var started : bool
var is_multi : bool

func _init():
	pause_mode = Node.PAUSE_MODE_PROCESS

remote func set_code(code):
	if get_tree().get_rpc_sender_id() != 1: return
	Globals.code = code
	var _a = get_tree().change_scene_to(load("res://level/LevelPlayer.tscn"))
	rpc_id(1, "done_loading")

remote func done_loading():
	if !get_tree().is_network_server(): return
	players_ready.append(get_tree().get_rpc_sender_id())

	if players_ready == player_ids:
		rpc("start_game")
		started = true
		get_tree().paused = false

remote func start_game():
	if get_tree().get_rpc_sender_id() != 1: return
	started = true
	get_tree().paused = false
