extends ScrollContainer

var level
var object_path = "res://level/backgrounds"
onready var container = $Control
onready var int_property = preload("res://level/editor/properties/IntProperty.tscn")
onready var int_property_2 = preload("res://level/editor/properties/IntProperty2.tscn")
onready var float_property = preload("res://level/editor/properties/FloatProperty.tscn")

onready var background_map = preload("res://level/backgrounds/background/IDMap.tres")
onready var foreground_map = preload("res://level/backgrounds/foreground/IDMap.tres")
onready var effect_map = preload("res://level/backgrounds/effects/IDMap.tres")

func get_property(key : String):
	return level.get_area(0)[key]

func set_property(key : String, new_value):
	level.get_area(0)[key] = new_value

func open(_level : Level):
	for child in container.get_children():
		child.queue_free()
	level = _level
	add_music_id()
	add_music_volume()
	add_backgrounds()
	add_foregrounds()
	add_effects()

func add_music_id():
	var property = int_property_2.instance()
	var params = [
		-1, 
		INF,
		1
	]
	property.load_property(self, "music_id", "Audio ID (NG)", params)
	container.add_child(property)

func add_music_volume():
	var property = float_property.instance()
	var params = [
		-80, 
		24,
		0.5
	]
	property.load_property(self, "music_volume", "Audio Volume (dB)", params)
	container.add_child(property)

func add_backgrounds():
	var property = int_property.instance()
	var params = [
		background_map.ids.size()
	]
	property.load_property(self, "background_id", "Sky", params)
	container.add_child(property)

func add_foregrounds():
	var property = int_property.instance()
	var params = [
		foreground_map.ids.size()
	]
	property.load_property(self, "foreground_id", "Backdrop", params)
	container.add_child(property)

func add_effects():
	var property = int_property.instance()
	var params = [
		effect_map.ids.size()
	]
	property.load_property(self, "effect_id", "Effects", params)
	container.add_child(property)
