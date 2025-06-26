extends CharacterBody2D
class_name Compagnon

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var speed := 200
var player: CharacterBody2D
var target_index := 0
var target_pos := Vector2.ZERO
@export var RefDistance : float
var player_trail : Line2D = null
var haut : bool = false
var bas : bool = false
var droite : bool = false
var gauche : bool = false
var direction := "down"
var last_direction := "null"
var state : String = "idle"

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

func _process(delta: float) -> void:
	_get_animation_direction(velocity)

func _physics_process(delta: float) -> void:
	if player_trail != null:
		var distance = global_position.distance_to(player.global_position)
		if player_trail.points.size() >= 5:
			$Label.text = str("Moving")
			var points : PackedVector2Array = player_trail.points
			var target_pos : Vector2 = points[target_index]
			var dir : Vector2 = (target_pos - global_position)
			if dir.length() < 4.0:
				player_trail.remove_point(target_index)			
			else:
				velocity = dir.normalized() * speed
			move_and_slide()
			state = ("Marche")
			last_direction = direction
			var anim_name = "Marche_" + direction
			if animation_player.current_animation != anim_name:
				animation_player.play(anim_name)
			
		else :
			$Label.text = str("not moving")
			state = ("idle")
			animation_player.stop()
			animation_player.play("idle_" + direction)

func _get_animation_direction(vel: Vector2) -> String:
	if vel == Vector2.ZERO:
		return last_direction  # Garde la dernière direction connue
	if abs(vel.x) > abs(vel.y):
		if vel.x > 0:
			direction = "droite"
		else:
			direction = "gauche"
	else:
		if vel.y > 0:
			direction = "down"
		else:
			direction = "up"
	return direction
