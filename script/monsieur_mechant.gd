extends Sprite2D

@export var pv : float = 100.0
var timer : float = 0.5

func _on_button_pressed() -> void:
	pv -= 10
	prints("AIE G", pv, "PV")
	
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("aie")
	
	
