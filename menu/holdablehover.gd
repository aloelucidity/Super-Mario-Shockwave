extends Button

export var label_text : String
export var hold_time : float
var time_left : float

signal time_up

func _physics_process(delta):
	if is_hovered():
		self_modulate = lerp(self_modulate, Color(0.7, 0.7, 0.7), delta * 6)
	else:
		self_modulate = lerp(self_modulate, Color.white, delta * 6)
	
	if pressed:
		self_modulate = Color.white
		time_left -= delta
		$Label.text = str(abs(ceil(time_left)))
		if time_left <= 0:
			emit_signal("time_up")
			pressed = false

func button_down():
	time_left = hold_time

func button_up():
	$Label.text = label_text
