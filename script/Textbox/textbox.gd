extends CanvasLayer

@onready var textbox_container : MarginContainer = $TexboxContainer
@onready var label : Label = $TexboxContainer/MarginContainer/HBoxContainer/Label
@onready var end_symbol : Label = $TexboxContainer/MarginContainer/HBoxContainer/End
@onready var textbox_image : TextureRect = $TexboxContainer/MarginContainer/HBoxContainer/MarginContainer/CharacterImage
var tween : Tween ## Tween pour l'animation du texte.

## La durée que met chaque caractère à s'afficher dans la boite de dialogue.
var CHAR_DISPLAY_DURATION = 0.05

## Une Textbox peut se trouver dans 3 états différents : [br]
## - State.[b]READY[/b] : La Textbox est en attente, pret à afficher sa prochaine ligne de dialogue. [br]   
## - State.[b]WRITING[/b] : Le texte est en train de s'écrire. [br]
## - State.[b]FINISHED[/b] : Le texte a fini d'etre écrit, la Textbox est en attente de l'input du joueur. 
enum State {
	## La Textbox est en attente, pret à afficher sa prochaine ligne de dialogue.
	READY,
	## Le texte est en train de s'écrire.
	WRITING,
	## Le texte a fini d'etre écrit, la Textbox est en attente de l'input du joueur.
	FINISHED,
}


## L'état courant de la Textbox. [br]
## Voir [enum State]
var current_state : State = State.READY 

## File d'attente stockant les prochaines boites de dialogue à afficher.
var queue : Array[TextboxContent] = []  

func _ready() -> void:
	textbox_container = $TexboxContainer
	label = $TexboxContainer/MarginContainer/HBoxContainer/Label
	end_symbol = $TexboxContainer/MarginContainer/HBoxContainer/End
	textbox_image = $TexboxContainer/MarginContainer/HBoxContainer/MarginContainer/CharacterImage	
	hide_textbox()
	

func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			if not queue.is_empty():
				display_text()
			
		State.WRITING:
			if Input.is_action_just_pressed("accept"):
				tween.stop()
				label.visible_ratio = 1
				end_symbol.text = "v"
				current_state = State.FINISHED
				
		State.FINISHED:
			if Input.is_action_just_pressed("accept"):
				if queue.is_empty():
					hide_textbox()
				else:
					flush_textbox()
					current_state = State.READY


func hide_textbox():
	flush_textbox()
	textbox_container.hide()

func flush_textbox():
	end_symbol.text = ""
	label.text = ""

func show_textbox():
	textbox_container.show()

func add_to_queue(content : TextboxContent):
	queue.push_back(content)

func display_text():
	current_state = State.WRITING
	
	var content : TextboxContent = queue.pop_front()
	textbox_image.texture = content.texture
	label.text = content.texte
	
	label.visible_ratio = 0
	
	tween = create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(label, "visible_ratio", 1, CHAR_DISPLAY_DURATION * len(label.text))
	tween.play()


func _on_tween_finished():
	end_symbol.text = "v"
	current_state = State.FINISHED
