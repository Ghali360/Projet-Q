extends Control

signal textbox_closed

@export var ennemi : Resource

func _ready() -> void:
	set_pv($QuentinContainer/ProgressBar, Stats.pv_max, Stats.current_pv)
	set_pv($EnemyContainer/ProgressBar, ennemi.pv, ennemi.pv)
	$EnemyContainer/Enemy.texture = ennemi.texture
	
	$Textbox.hide()
	$AttaqueButton.hide()
	
	display_text("Oh non ! un %s sauvage attaque !" % [ennemi.name.to_upper()])
	await textbox_closed
	$AttaqueButton.show()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("action"):
		$Textbox.hide()
		emit_signal("textbox_closed") 


func set_pv(progressBar : ProgressBar, pv_max, current_pv):
	progressBar.max_value = pv_max
	progressBar.value = current_pv
	progressBar.get_node("Label").text = "%d/%d" % [current_pv, pv_max]


func display_text(text):
	$Textbox/Label.text = text
	$Textbox.show()
	

func _on_attaque_button_pressed() -> void:
	$AttaqueButton.hide()
	display_text("Quentin attaque !");
	await textbox_closed;
	
	$AttaqueButton.show()
