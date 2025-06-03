extends Control

## Signal émis quand la boite de texte se ferme.
signal textbox_closed

@export var ennemi : Resource

func _ready() -> void:
	set_pv($QuentinContainer/ProgressBar, Stats.pv_max, Stats.current_pv)
	set_pv($EnemyContainer/ProgressBar, ennemi.pv, ennemi.pv)
	$EnemyContainer/Enemy.texture = ennemi.texture
	
	$AttaqueButton.hide()
	
	$TextboxManager.start_dialogue()
	$AttaqueButton.show()



func set_pv(progressBar : ProgressBar, pv_max, current_pv):
	progressBar.max_value = pv_max
	progressBar.value = current_pv
	progressBar.get_node("Label").text = "%d/%d" % [current_pv, pv_max]


func _on_attaque_button_pressed() -> void:
	$AttaqueButton.hide()
	#display_text("Quentin attaque !");
	await textbox_closed;
	
	$AttaqueButton.show()
