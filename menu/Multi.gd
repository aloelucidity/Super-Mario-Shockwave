extends Node2D

var players_ready = []

func _ready():
	get_tree().connect("network_peer_connected", self, "success")

func host_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_server(4242, 16)
	get_tree().network_peer = net
	Globals.code = $TextEdit.text

func join_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_client("127.0.0.1", 4242)
	get_tree().network_peer = net

func success(id):
	Multi.is_multi = true
	Multi.player_ids.append(id)
	get_tree().paused = true
	if get_tree().is_network_server():
		Multi.rpc("set_code", Globals.code)
		var _a = get_tree().change_scene_to(load("res://level/LevelPlayer.tscn"))
