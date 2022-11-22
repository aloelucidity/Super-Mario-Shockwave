extends AudioStreamPlayer

export(Array, AudioStream) var songs
export(Array, float) var volume_levels

func _ready():
	randomize()
	pick_song()
	connect("finished", self, "pick_song")

func pick_song():
	var song_index = randi() % songs.size()
	stream = songs[song_index]
	volume_db = volume_levels[song_index]
	play()
