extends Control

func import_level(code: String):
	var uuid_util = preload('res://misc/uuid.gd')
	if code == "":
		code = $TextEdit.text
	
	var file = File.new()
	file.open("user://saved_levels/" + uuid_util.v4() + ".txt", File.WRITE)
	file.store_string(code)
	file.close()
	
	get_parent().go_back()

func new_level():
	var file = File.new()
	file.open("res://level/default_level.tres", file.READ)
	import_level(file.get_as_text())
	file.close()
