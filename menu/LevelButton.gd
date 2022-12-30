extends Button

var code : String
var level_info

onready var label = $Label
onready var thumbnail = $Thumbnail

func _ready():
	if code == "": return
	level_info = LevelCode.get_lvl_info(code)
	label.text = level_info.level_name
	if level_info.thumbnail_url.begins_with("res://"):
		thumbnail.texture = load(level_info.thumbnail_url)
