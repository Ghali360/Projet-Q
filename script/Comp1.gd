extends Compagnon
var player_trail : Line2D = null

func _ready() -> void:
	call_deferred("_Assign_trail")

func _Assign_trail():
	var root = get_tree().get_current_scene()
	player = root.find_child("player")
	player_trail = player.get_child(3)
	if player_trail == null :
		print("NoTRAIL")
	else :
		print("Trail")
	
func _physics_process(delta: float) -> void:
	get_child(0).text = str(player.global_position)
	if player_trail != null:
		var points : PackedVector2Array = player_trail.points
		if target_index >= points.size():
			return  # on a atteint la fin de la traînée
			var target_pos : Vector2 = points[target_index]
			var dir : Vector2 = (target_pos - global_position)
			if dir.length() < 4.0:
				target_index += 1
			else:
				velocity = dir.normalized() * speed
				move_and_slide()
