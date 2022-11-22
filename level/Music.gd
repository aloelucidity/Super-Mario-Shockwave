extends Node2D
const Downloader = preload("res://misc/downloader.gd")

onready var downloader = Downloader.new()

func load_song(id):
	id = 516709
	
	downloader.connect("download_completed", self, "html_completed", [id], CONNECT_ONESHOT)
	downloader.download("https://www.newgrounds.com/audio/listen/" + str(id), "user://page.html")
	print("Getting song URL...")

func html_completed(id):
	var html_data = File.new()
	html_data.open("user://page.html", File.READ)
	var text_data = html_data.get_as_text()
	var start_index = text_data.find('{"filename":') + 13
	var end_index = text_data.find('"', start_index)
	var song_url = text_data.substr(start_index, end_index - start_index)
	song_url = song_url.replace("\\", "")
	print(song_url)
	
	downloader.connect("download_completed", self, "download_completed", [], CONNECT_ONESHOT)
	downloader.download(song_url)
	print("Loading song...")

func download_completed():
	var music_data = File.new()
	music_data.open("user://music.mp3", File.READ)
	
	var bytes = music_data.get_buffer(music_data.get_len())
	var audio_stream := AudioStreamMP3.new()
	audio_stream.data = bytes
	audio_stream.loop = true
	if audio_stream.data == null:
		return
	music_data.close()
	
	$Music.stream = audio_stream
	$Music.volume_db = -3.5
	$Music.play()
	print("Song loaded.")
