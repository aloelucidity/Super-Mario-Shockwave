extends ScrollContainer

func open(level : Level):
	var encode = LevelCode.encode_level(level.save_level())
	$Control/TextEdit.text = encode
	if OS.get_name() == "HTML5":
		$Control/Label.text = "Pasting from clipboard is currently unsupported in HTML5 exports. Sorry!"
	update_copy()

func update_copy():
	$Control/Buttons/Copy.disabled = ($Control/TextEdit.text == OS.clipboard.strip_edges())

func copy_code():
	OS.clipboard = $Control/TextEdit.text
	update_copy()

func load_code():
	Globals.code = $Control/TextEdit.text
	var _scene = get_tree().reload_current_scene()
