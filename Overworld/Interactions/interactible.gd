extends Area2D
class_name Interactible

@export var interact_name : String = ""
@export var is_interactif : bool = true
@export var target_level: String = "Overworld_2"
@export var spawn_point: Vector2 = Vector2(100, 100)
var interact : Callable = func ():
	pass
