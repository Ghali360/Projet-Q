extends AudioStreamPlayer

const doorFX = preload("res://Sounds/FX/door open.ogg")

func _play_music(music : AudioStream, volume = 0.0) :
	if stream == music :
		return
		
	stream = music
	volume_db = volume
	play()
	
func _play_doorFX():
	_play_music(doorFX)

func _play_interact():
	pass
