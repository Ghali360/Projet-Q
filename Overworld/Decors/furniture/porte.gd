extends StaticBody2D

@onready var interactible: Area2D = $Interactible
@onready var sprite_2d: Sprite2D = $Sprite2D

const File_Begin = "res://Overworld/overworld_"

func _ready() -> void:
	interactible.interact = _on_interact
	
func _on_interact():
	if sprite_2d.frame == 0:
		sprite_2d.frame = 1
		interactible.is_interactif = false
		print("Azog touché")
		await _next_level()
		
func _next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_nbr = current_scene_file.to_int() + 1
	var next_level_path = File_Begin+str(next_level_nbr)+".tscn"
	FadeScreen._transition()
	await FadeScreen.on_transition_finished
	get_tree().change_scene_to_file(next_level_path)
