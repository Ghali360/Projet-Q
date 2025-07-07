extends Trails

func _get_position():
	return get_parent().position

func _on_node_2d_moving() -> void:
	if Trace == false:
		Trace = true

func _on_node_2d_not_moving() -> void:
	if Trace == true:
		Trace = false # Replace with function body.
