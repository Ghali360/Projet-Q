extends Node
class_name DialogueManager
## Permet de gérer un dialogue par boite de texte. 

signal dialogue_finished 	## Signal émis lorsque toutes les boites de dialogues ont été affichées.
signal dialogue_stopped 	## Signal émis lorsque la boite de dialogue s'est fermée.

@onready var textbox_scene : Resource = preload("res://Textbox/Textbox.tscn")
var textbox : Node

## L'indice de la prochaine boite de dialogue à afficher.
var current_dialogue_index : int = 0

@export var lignes_de_dialogue : Array[TextboxContent] = []
@onready var nb_lignes = len(lignes_de_dialogue) ## Le nombre total de lignes de dialogues

@export_group("Font")
@export var font : Font
@export var font_color : Color = Color.WHITE
@export_range(1,100,1) var font_size : int = 45


## Crée une instance de textbox vide.
func _create_textbox():
	if textbox != null:
		_delete_textbox() # On supprime une éventuelle textbox précédente au cas où
	
	print("dialogue starting")
	
	textbox = textbox_scene.instantiate()
	get_tree().root.add_child.call_deferred(textbox)
	await textbox.ready
	
	textbox.textbox_closed.connect(_on_textbox_closed)
	
	print("Affichage de la fenetre")
	textbox.show_textbox()

## Supprime la textbox de la scène.
func _delete_textbox():
	textbox.queue_free()


## Ouvre la boite de texte et lance les n premières lignes de dialogue. \n
## Si n = 0, lance le dialogue jusqu'à la fin.
func start_dialogue(n:int = 0):
	#nb_lignes = len(lignes_de_dialogue)
	
	current_dialogue_index = 0
	_create_textbox()

	# On affiche tout le texte restant
	if n <= 0:
		for content : TextboxContent in lignes_de_dialogue:
			_load_textbox_content(content)
		current_dialogue_index = nb_lignes
		
	else:
		# On affiche les n lignes de dialogues suivantes.
		# Si il y a moins que n lignes de dialogues, on s'arrete à la fin.
		for i in range(n):
			if i >= nb_lignes:
				break
			else: 
				_load_textbox_content(lignes_de_dialogue[i])
				current_dialogue_index += 1 

## Réouvre la boite de texte, et affiche les n lignes de dialogues suivantes.
## Si n=0, continue jusqu'à la fin.
func continue_dialogue(n:int = 0):
	if n <= 0:
		finish_dialogue()
	else:
		if textbox == null and current_dialogue_index < nb_lignes:
			_create_textbox()
		
		for i in range(n):
			if current_dialogue_index == nb_lignes:
				break
			else:
				_load_textbox_content(lignes_de_dialogue[current_dialogue_index])
				current_dialogue_index += 1

## Réouvre la boite de texte, et affiche le restant du dialogue.
func finish_dialogue():
	if textbox == null and current_dialogue_index < nb_lignes:
		_create_textbox()
	
	for i in range(current_dialogue_index, nb_lignes):
		_load_textbox_content(lignes_de_dialogue[i])
	current_dialogue_index = nb_lignes



## Charge un textContent dans le Textbox.
func _load_textbox_content(content : TextboxContent):
	# Si la textboxContent n'a pas de font custom, on met ceux du DialogManager a la place 
	if not content.font_custom:
		content.font = font
		content.font_color = font_color
		content.font_size = font_size
	
	textbox.add_to_queue(content)


func _on_textbox_closed():
	dialogue_stopped.emit()
	print("dialogue_stopped")
	_delete_textbox()
	
	if current_dialogue_index == len(lignes_de_dialogue):
		dialogue_finished.emit()
		print("& dialogue finished")
