extends Area2D

@export var widexime : float = 3

var clickable : bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("clic") and clickable:
		scale.x = widexime
		
	if Input.is_action_just_released("clic"):
		scale.x = 1



func _on_mouse_entered() -> void:
	print("ENTREEE")
	clickable = true

func _on_mouse_exited() -> void:
	print("SORTIEEEE")
	clickable = false
