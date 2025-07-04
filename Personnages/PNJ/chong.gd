extends StaticBody2D

@onready var interactible: Area2D = $Interactible
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var dialogue = $DialogueManager
@onready var soundPlayer = $AudioStreamPlayer

func _ready() -> void:
	interactible.interact = _on_interact
	
func _on_interact():
	if sprite_2d.frame == 0:
		sprite_2d.frame = 1
		interactible.is_interactif = false
		print("Chong Touché")
		await _Dialogue()
		
func _Dialogue():
	soundPlayer.play()
	dialogue.start_dialogue(0)
	await dialogue.dialogue_stopped
	soundPlayer.stop()
	interactible.is_interactif = true
