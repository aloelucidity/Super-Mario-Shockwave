extends Node2D

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F:
			Globals.coinCount += 1
func _process(delta):
	# this probably could be optimized but im lazy and kinda new to godot -Mememan
	if Globals.coinCount >= 0:
		$RichTextLabel.text = '0000'
		$RichTextLabel2.text = '0000'
		$RichTextLabel3.text = '0000'			
	if Globals.coinCount >= 1:
		$RichTextLabel.text = '000' + str(Globals.coinCount)
		$RichTextLabel2.text = '000' + str(Globals.coinCount)
		$RichTextLabel3.text = '000' + str(Globals.coinCount)		
	if Globals.coinCount >= 10:
		$RichTextLabel.text = '00' + str(Globals.coinCount)
		$RichTextLabel2.text = '00' + str(Globals.coinCount)
		$RichTextLabel3.text = '00' + str(Globals.coinCount)	
	if Globals.coinCount >= 100:
		$RichTextLabel.text = '0' + str(Globals.coinCount)
		$RichTextLabel2.text = '0' + str(Globals.coinCount)
		$RichTextLabel3.text = '0' + str(Globals.coinCount)		
	if Globals.coinCount >= 1000:
		$RichTextLabel.text = str(Globals.coinCount)
		$RichTextLabel2.text = str(Globals.coinCount)
		$RichTextLabel3.text = str(Globals.coinCount)
	if Globals.coinCount >= 9999:
		Globals.coinCount = 9999
		$RichTextLabel.text = '9999'
		$RichTextLabel2.text = '9999'
		$RichTextLabel3.text = '9999'											
	
