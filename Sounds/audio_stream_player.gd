extends AudioStreamPlayer

const level_music = preload("res://Sounds/Musics/The Slumbering Cerulean Thicket [TubeRipper.cc].ogg")

func _play_music(music : AudioStream, volume = -10.0) :
	if stream == music :
		return
		
	stream = music
	volume_db = volume
	play()
	
func _play_music_level():
	_play_music(level_music)
