extends Node
class_name TextboxManager

@onready var textbox_scene = preload("res://Scenes/Textbox.tscn")
var textbox : Node

@export var lignes_de_dialogue : Array[TextboxContent] = []

#  Lance le dialogue.
func start_dialogue():
	print("dialogue starting")
	
	textbox = textbox_scene.instantiate()
	get_tree().root.add_child.call_deferred(textbox)

	await textbox.ready
	
	print("Affichage de la fenetre")
	textbox.show_textbox()
	
	print("load lignes de dialogues dans le textbox")
	for content in lignes_de_dialogue:
		load_textbox_content(content)


func load_textbox_content(content : TextboxContent):
	textbox.add_to_queue(content)
