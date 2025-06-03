extends Node
class_name DialogueManager
## Permet de gérer un dialogue par boite de texte. 


@onready var textbox_scene = preload("res://Scenes/Textbox.tscn")
var textbox : Node


@export var lignes_de_dialogue : Array[TextboxContent] = []

@export_group("Font")
@export var font : Font
@export var font_color : Color = Color.WHITE
@export_range(1,100,1) var font_size : int = 45



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
	# Si la textboxContent n'a pas de font custom, on met ceux du DialogManager a la place 
	if not content.font_custom:
		content.font = font
		content.font_color = font_color
		content.font_size = font_size
	
	textbox.add_to_queue(content)
