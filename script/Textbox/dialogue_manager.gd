extends Node
class_name DialogueManager
## Permet de gérer un dialogue par boite de texte. 


@onready var textbox_scene = preload("res://Scenes/Textbox.tscn")
var textbox : Node

@export var lignes_de_dialogue : Array[TextboxContent] = []


## Lance le dialogue et ouvre la boite de texte.
func start_dialogue():
	print("dialogue starting")
	
	textbox = textbox_scene.instantiate()
	get_tree().root.add_child.call_deferred(textbox)
	await textbox.ready
	
	print("Affichage de la fenetre")
	textbox.show_textbox()
	
	print("load lignes de dialogues dans le textbox")
	for content in lignes_de_dialogue:
		_load_textbox_content(content)

## Charge un textContent dans le Textbox.
func _load_textbox_content(content : TextboxContent):
	textbox.add_to_queue(content)
