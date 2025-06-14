extends Control

@export var ennemi : Resource
@onready var intro_dialogue = $IntroDialogue

func _ready() -> void:
	set_pv($QuentinContainer/ProgressBar, Stats.pv_max, Stats.current_pv)
	set_pv($EnemyContainer/ProgressBar, ennemi.pv, ennemi.pv)
	$EnemyContainer/Enemy.texture = ennemi.texture
	
	$AttaqueButton.hide()
	
	intro_dialogue.start_dialogue(2)
	$AttaqueButton.show()



func set_pv(progressBar : ProgressBar, pv_max, current_pv):
	progressBar.max_value = pv_max
	progressBar.value = current_pv
	progressBar.get_node("Label").text = "%d/%d" % [current_pv, pv_max]


func _on_attaque_button_pressed() -> void:
	$AttaqueButton.hide()
	intro_dialogue.finish_dialogue()

	await intro_dialogue.dialogue_stopped
	$AttaqueButton.show()
