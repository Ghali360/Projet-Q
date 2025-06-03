extends CanvasLayer

@onready var textbox_container : MarginContainer = $TexboxContainer
@onready var label : Label = $TexboxContainer/MarginContainer/HBoxContainer/Label
@onready var end_symbol : Label = $TexboxContainer/MarginContainer/HBoxContainer/End
@onready var tween : Tween # Tween pour l'animation du texte

var CHAR_DISPLAY_DURATION = 0.05

enum State {
	READY,
	WRITING,
	FINISHED
} 

var current_state : State = State.READY
var text_queue : Array[String] = []

func _ready() -> void:
	hide_textbox()
	show_textbox()
	
	
	#Exemple temporaire
	add_to_queue("macron exlpsoion")
	add_to_queue("explosiooonnnnnnnnnnnn")
	add_to_queue("...")
	add_to_queue("attend macron c'est moi")
	add_to_queue("oh noooonnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn")


func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				display_text()
			
		State.WRITING:
			if Input.is_action_just_pressed("ui_accept"):
				tween.stop()
				label.visible_ratio = 1
				end_symbol.text = "v"
				current_state = State.FINISHED
				
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				if text_queue.is_empty():
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

func add_to_queue(text):
	text_queue.push_back(text)

func display_text():
	current_state = State.WRITING
	label.text = text_queue.pop_front()
	label.visible_ratio = 0
	
	tween = create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(label, "visible_ratio", 1, CHAR_DISPLAY_DURATION * len(label.text))
	tween.play()


func _on_tween_finished():
	end_symbol.text = "v"
	current_state = State.FINISHED
