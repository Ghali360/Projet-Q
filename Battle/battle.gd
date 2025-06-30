extends Control

@export var perso : Personnage
@export var ennemi : Resource

@export var pv : int 

@onready var intro_dialogue = $IntroDialogue

func _ready() -> void:
	
	
	set_pv($QuentinContainer/ProgressBar, Stats.pv_max, Stats.current_pv)
	set_pv($EnemyContainer/ProgressBar, ennemi.pv, ennemi.pv)
	$EnemyContainer/Enemy.texture = ennemi.texture
	
	$AttaqueButton.hide()
	
	intro_dialogue.start_dialogue(3)
	await intro_dialogue.dialogue_stopped
	intro_dialogue.continue_dialogue(3)
	intro_dialogue.finish_dialogue()
	
	
	$AttaqueButton.show()



func set_pv(progressBar : ProgressBar, pv_max, current_pv):
	progressBar.max_value = pv_max
	progressBar.value = current_pv
	progressBar.get_node("Label").text = "%d/%d" % [current_pv, pv_max]


func _on_attaque_button_pressed() -> void:
	$AttaqueButton.hide()
	$AttaqueButton/AttaqueDialogue.start_dialogue()

	await $AttaqueButton/AttaqueDialogue.dialogue_stopped
	$AttaqueButton.show()
