extends Control

func _ready():
	Globals.level.connect("coin_collected", self, "coin_collected")

func coin_collected():
	var coins = Globals.level.persistent_data.coins
	for child in get_children():
		if child is RichTextLabel:
			child.text = str(coins).pad_zeros(4)
