extends LineEdit

func _input(event):
	if event.is_action_pressed("textbox_enter_fuckyou") && get_focus_owner() == self:
		yield(get_tree(), "idle_frame")
		release_focus()
		emit_signal("text_entered")
	if event.is_action_pressed("textbox_escape") && get_focus_owner() == self:
		release_focus()
