extends Node2D

func _ready() -> void:
	GlobalAudioStreamPlayer._play_music_level()
	# Charger sauvegarde si elle existe
	if GlobalState.load_game():
		# Déterminer le niveau à charger
		var target_level = "Overworld_1"
		if GlobalState.saved_positions.has("Overworld_2"):
			target_level = "Overworld_2"
		
		get_tree().change_scene_to_file("res://" + target_level + ".tscn")
	else:
		# Nouvelle partie - charger Overworld_
		get_tree().change_scene_to_file("res://Overworld_1.tscn")
