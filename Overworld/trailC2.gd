extends Trails

func _get_position():
	return get_parent().position

func _on_compagnon_2_moving() -> void:
	if Trace == false:
		Trace = true

func _on_compagnon_2_not_moving() -> void:
	if Trace == true:
		Trace = false 
