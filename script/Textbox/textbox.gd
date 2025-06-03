extends CanvasLayer

@onready var textbox_container : MarginContainer = $TexboxContainer
@onready var label : Label = $TexboxContainer/MarginContainer/HBoxContainer/Label
@onready var end_symbol : Label = $TexboxContainer/MarginContainer/HBoxContainer/End
@onready var textbox_image : TextureRect = $TexboxContainer/MarginContainer/HBoxContainer/MarginContainer/CharacterImage
var tween : Tween ## Tween pour l'animation du texte.

## La (durée en millisecondes) que met chaque caractère à s'afficher dans la boite de dialogue.
const CHAR_DISPLAY_DURATION = 50

## La vitesse de défilement du texte. 100 = "100% de la vitesse normale".
var vitesse_defilement : float = 100

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

# Masques pour récupérer les flags de TextboxContent.skip_options.
const INSKIPABLE_FLAG = 0b1
const AUTOSKIP_FLAG = 0b01


var autoskip : bool = false		## Détermine si la boite de dialogue se ferme automatiquement après la fin du texte.
var inskipable : bool = false	## Détermine si le texte défilant peut être passé directement ou non.

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
			if Input.is_action_just_pressed("accept") and not inskipable:
				tween.stop()
				label.visible_ratio = 1
				end_symbol.text = "v"
				current_state = State.FINISHED
				
		State.FINISHED:
			if Input.is_action_just_pressed("accept") or autoskip:
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
	textbox_image.hide()

func show_textbox():
	textbox_container.show()

func add_to_queue(content : TextboxContent):
	queue.push_back(content)

func display_text():
	
	var content : TextboxContent = queue.pop_front()
	_load_content(content)
	
	label.visible_ratio = 0
	
	tween = create_tween()
	tween.finished.connect(_on_tween_finished)
	
	var duration = CHAR_DISPLAY_DURATION * len(label.text) / 1000.0
	duration = duration * (100/vitesse_defilement)
	
	print("texte :", label.text, ", len : ", len(label.text))
	print("vitesse défilement :", vitesse_defilement)
	print("duration : ", duration)
	
	current_state = State.WRITING
	tween.tween_property(label, "visible_ratio", 1, duration)
	tween.play()


## Charge les données de la textbox dans les variables internes.
func _load_content(content : TextboxContent):
	
	# Affichage image
	if content.texture != null:
		textbox_image.texture = content.texture
		textbox_image.show()
	
	#Texte
	label.text = content.texte
	
	#Vitesse défilement du texte
	vitesse_defilement = content.vitesse_défilement_texte

	# Skip options
	autoskip = content.skip_options & AUTOSKIP_FLAG
	inskipable = content.skip_options & INSKIPABLE_FLAG


func _on_tween_finished():
	end_symbol.text = "v"
	current_state = State.FINISHED
