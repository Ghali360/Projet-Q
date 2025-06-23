extends Line2D
class_name Trails
var Trace : bool = false
var NbrP : int = 0
var timer : float = 0.1

func _process(delta: float) -> void:
	if Trace:
		timer -= delta
		if timer <= 0:
			var pos = _get_position()
			add_point(pos)
			NbrP += 1 
			print("point"+str(NbrP))
			timer = 0.1

func _get_position():
	return get_global_mouse_position()
