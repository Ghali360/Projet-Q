extends Node2D
class_name Porte
@onready var interactible: Interactible = $Interactible
@onready var sprite_2d: Sprite2D = $Sprite2D
var File_Begin: String = "res://Overworld/overworld_"

func _ready() -> void:
	interactible.interact = _on_interact

func _on_interact():
	if sprite_2d.frame == 0 and interactible.is_interactif:
		sprite_2d.frame = 1
		print("Azog touches")
		interactible.is_interactif = false
		await _next_level()

func _next_level():
	var player: Node = null
	var players = get_tree().get_nodes_in_group("Player")  # Notez le 'P' majuscule
	if players.size() > 0:
		player = players[0]
	else:
		player = get_tree().current_scene.find_child("player", true, false)
	if player == null:
		push_error("Player node not found!")
		return
	FxStreamPlayer._play_doorFX()
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_nbr = current_scene_file.to_int() + 1
	var next_level_path = File_Begin + str(next_level_nbr) + ".tscn"
	FadeScreen._transition()
	player.save_position()
	
	# 6. Sauvegarder le jeu
	GlobalState.save_game()
	await FadeScreen.on_transition_finished
	interactible.is_interactif = true
	get_tree().change_scene_to_file(next_level_path)
