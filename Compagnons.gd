extends CharacterBody2D
@export var speed := 200
@onready var player: CharacterBody2D
var target_index := 0
var target_pos := Vector2.ZERO

func _ready() -> void:
	call_deferred("AssingPlayer")

func AssingPlayer():
	player = $"../player"

func _physics_process(delta: float) -> void:
	if player != null :
		$Label.text = str(player.global_position)
		var distance = global_position.distance_to(player.global_position)
		if distance > 100:
			if player and player.position_history.size() > target_index:
				target_pos = player.position_history[target_index]
				var direction = (target_pos - global_position).normalized()
				velocity = direction * speed
				move_and_slide()
	else :
		$Label.text = str("attente")

		
		#if distance < 4:
			#target_index += 1
