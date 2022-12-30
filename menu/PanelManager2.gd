extends Node2D

onready var animation_player = $AnimationPlayer

export var starting_path : NodePath
onready var starting_panel = get_node(starting_path)
onready var current_panel = starting_panel

var transitioning : bool

func go_back():
	if current_panel.name != starting_panel.name:
		open_panel(starting_panel)

func open_panel_by_path(path : NodePath):
	open_panel(get_node(path))

func open_panel(new_panel):
	if transitioning: return
	if new_panel != current_panel:
		transitioning = true
		
		animation_player.play("close_" + current_panel.name)
		yield(animation_player, "animation_finished")
		animation_player.play("open_" + new_panel.name)
		current_panel = new_panel
		
		transitioning = false

		if new_panel.name == "Levels":
			$Levels/SavedLevels.load_levels()

func quit():
	transitioning = true
	animation_player.play("close_" + current_panel.name)
	yield(animation_player, "animation_finished")
	get_tree().quit()
