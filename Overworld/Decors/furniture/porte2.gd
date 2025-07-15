extends Porte

func _next_level():
	FxStreamPlayer._play_doorFX()
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_nbr = current_scene_file.to_int() - 1
	var next_level_path = File_Begin+str(next_level_nbr)+".tscn"
	FadeScreen._transition()
	$"../player".save_position()
	GlobalState.save_game()
	await FadeScreen.on_transition_finished
	get_tree().change_scene_to_file(next_level_path)
