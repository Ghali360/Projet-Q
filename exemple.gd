extends Node2D

func _ready():
	$Dialogue_intro.start_dialogue()


func _on_insulte_pressed() -> void:
	$insulte/DialogueManager.start_dialogue()
	

func _on_compliment_pressed() -> void:
	$compliment/DialogueManager.start_dialogue()
