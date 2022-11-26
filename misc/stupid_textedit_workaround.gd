extends TextEdit

func _input(event):
	if event.is_action_pressed("textbox_escape") && get_focus_owner() == self:
		release_focus()
