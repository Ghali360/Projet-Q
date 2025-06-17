extends Node2D

func _ready() -> void:
	pass

@export var on_peut_afficher_le_texte : bool = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and on_peut_afficher_le_texte:
		$DialogueManager.start_dialogue()
		on_peut_afficher_le_texte = false


func _on_dialogue_finished() -> void:
	on_peut_afficher_le_texte = true
