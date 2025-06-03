class_name player
extends CharacterBody2D

var speed : float = 100
var direction : Vector2 = Vector2.ZERO
var cardinal_direction : Vector2 = Vector2.DOWN
var state : String = "idle"
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
func _process(delta: float) -> void:
	
	direction.x = Input.get_action_strength("droite") - Input.get_action_strength("gauche")
	direction.y = Input.get_action_strength("bas") - Input.get_action_strength("haut")
	
	velocity = direction * speed
	cardinal_direction = direction
	if SetState() == true : #|| SetDirection() == true :
		UpdateAnimation()
	#print (state)
func _physics_process(delta: float) -> void:
	move_and_slide()
	
func SetDirection() -> bool :
	var new_dir : Vector2 = cardinal_direction
	if direction  == Vector2.ZERO:
		return false
	if direction.y == 0 :
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0 :
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_dir == cardinal_direction :
		return false
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
func SetState() -> bool :
	var newState : String = "idle" if direction == Vector2.ZERO else "Marche"
	if newState == state:
		return false
		state = newState
		print (state)
	return true
	
func UpdateAnimation() -> void :
	animation_player.play (state + "_" + AnimDirection())
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN :
		return "down"
	elif cardinal_direction == Vector2.UP :
		return "up"
	elif cardinal_direction == Vector2.LEFT :
		return "gauche"
	elif cardinal_direction == Vector2.RIGHT :
		return "droite"
	elif cardinal_direction == Vector2.RIGHT + Vector2.UP :
		return "up"
	elif cardinal_direction == Vector2.LEFT + Vector2.UP :
		return "up"
	else :
		return "down"
