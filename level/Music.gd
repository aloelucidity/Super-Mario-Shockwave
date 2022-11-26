extends Node2D
const Downloader = preload("res://misc/downloader.gd")

onready var downloader = Downloader.new()
var volume = -4

func load_song(id):
	if id == -1: return
	var directory = Directory.new()
	if !directory.dir_exists("user://music"):
		directory.make_dir("user://music")

	if directory.file_exists("user://music/" + str(id) + ".mp3"):
		print(str(id) + ".mp3 already exists!")
		download_completed(id)
	else:
		downloader.connect("download_completed", self, "html_completed", [id], CONNECT_ONESHOT)
		downloader.download("https://www.newgrounds.com/audio/listen/" + str(id), "user://music/page.html")
		print("Getting song URL...")

func html_completed(id):
	var html_data = File.new()
	html_data.open("user://music/page.html", File.READ)
	var text_data = html_data.get_as_text()
	var start_index = text_data.find('{"filename":') + 13
	var end_index = text_data.find('"', start_index)
	var song_url = text_data.substr(start_index, end_index - start_index)
	song_url = song_url.replace("\\", "")
	print(song_url)
	
	downloader.connect("download_completed", self, "download_completed", [id], CONNECT_ONESHOT)
	downloader.download(song_url, "user://music/" + str(id) + ".mp3")
	print("Loading song...")

func download_completed(id):
	var music_data = File.new()
	music_data.open("user://music/" + str(id) + ".mp3", File.READ)
	
	var bytes = music_data.get_buffer(music_data.get_len())
	var audio_stream := AudioStreamMP3.new()
	audio_stream.data = bytes
	audio_stream.loop = true
	if audio_stream.data == null:
		return
	music_data.close()
	
	$Music.stream = audio_stream
	$Music.volume_db = volume
	$Music.play()
	print("Song loaded.")
