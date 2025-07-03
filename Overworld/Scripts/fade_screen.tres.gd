extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

signal on_transition_finished

func _ready() -> void:
	#color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	

func _on_animation_finished(anim_name):
	if anim_name == "fade_animation_to_black" :
		on_transition_finished.emit()
		animation_player.play("fade_animation_to_nothing")
	#elif anim_name == "fade_animation_to_nothing" :
		#color_rect.visible = false

func _transition() :
	animation_player.play("fade_animation_to_black")
	
