extends CharacterBody2D
class_name Compagnon

@export var speed := 200
var player: CharacterBody2D
var target_index := 0
var target_pos := Vector2.ZERO
@export var RefDistance : float
var player_trail : Line2D = null

func _ready() -> void:
	call_deferred("AssingPlayer")

func AssingPlayer():
	var root = get_tree().get_current_scene()
	player = root.find_child("player")
	player_trail = player.get_child(3)
	if player_trail == null :
		print("NoTRAIL")
	else :
		print("Trail")


func _physics_process(delta: float) -> void:
	if player_trail != null:
		var distance = global_position.distance_to(player.global_position)
		if distance > RefDistance:
			$Label.text = str("Moving")
			var points : PackedVector2Array = player_trail.points
			if target_index >= points.size():
				return  # on a atteint la fin de la traînée
			var target_pos : Vector2 = points[target_index]
			var dir : Vector2 = (target_pos - global_position)
			if dir.length() < 4.0:
				player_trail.remove_point(target_index)			
			else:
				velocity = dir.normalized() * speed
			move_and_slide()
		else :
			$Label.text = str("not moving")
