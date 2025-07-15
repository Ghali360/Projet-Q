extends Porte

func _ready() -> void:
	interactible.interact = _on_interact
	interactible.is_interactif = false
