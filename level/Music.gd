extends AudioStreamPlayer
const Downloader = preload("res://misc/downloader.gd")

onready var level_info = get_parent()
onready var downloader = Downloader.new()

func _ready():
	downloader.connect("download_completed", self, "download_completed")
	downloader.download(level_info.music_url)
	print("Loading custom music...")

func download_completed():
	var music_data = File.new()
	music_data.open("user://music.ogg", File.READ)
	
	var bytes = music_data.get_buffer(music_data.get_len())
	var audio_stream := AudioStreamOGGVorbis.new()
	audio_stream.data = bytes
	audio_stream.loop = true
	if audio_stream.data == null:
		return
	music_data.close()
	
	stream = audio_stream
	play()
	print("Custom music loaded.")
