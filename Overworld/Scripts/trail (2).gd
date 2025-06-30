extends Trails

func _get_position():
	return get_parent().position


func _on_player_marche() -> void:
	if Trace == false:
		Trace = true # Replace with function body.


func _on_player_idle() -> void:
	if Trace == true:
		Trace = false # Replace with function body.
