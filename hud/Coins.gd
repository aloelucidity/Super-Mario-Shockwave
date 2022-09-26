extends Node2D

var coinCount : int

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F:
			coinCount += 1
func _process(delta):
	# this probably could be optimized but im lazy and kinda new to godot -Mememan
	coinCount = Globals.coinCount	
	if coinCount >= 0:
		$RichTextLabel.text = '0000'
		$RichTextLabel2.text = '0000'
		$RichTextLabel3.text = '0000'			
	if coinCount >= 1:
		$RichTextLabel.text = '000' + str(coinCount)
		$RichTextLabel2.text = '000' + str(coinCount)
		$RichTextLabel3.text = '000' + str(coinCount)		
	if coinCount >= 10:
		$RichTextLabel.text = '00' + str(coinCount)
		$RichTextLabel2.text = '00' + str(coinCount)
		$RichTextLabel3.text = '00' + str(coinCount)	
	if coinCount >= 100:
		$RichTextLabel.text = '0' + str(coinCount)
		$RichTextLabel2.text = '0' + str(coinCount)
		$RichTextLabel3.text = '0' + str(coinCount)		
	if coinCount >= 1000:
		$RichTextLabel.text = str(coinCount)
		$RichTextLabel2.text = str(coinCount)
		$RichTextLabel3.text = str(coinCount)
	if coinCount >= 9999:
		coinCount = 9999
		$RichTextLabel.text = '9999'
		$RichTextLabel2.text = '9999'
		$RichTextLabel3.text = '9999'											
	
