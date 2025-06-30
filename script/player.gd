class_name player
extends CharacterBody2D

@export var speed : float = 200
var direction : Vector2 = Vector2.ZERO
var cardinal_direction : Vector2 = Vector2.DOWN
var state : String = "idle"
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var trail_line : Line2D = $TrailLine
var haut : bool = false
var bas : bool = false
var droite : bool = false
var gauche : bool = false
var currentAnim : String = ""
var LastDirection : String = ""
var position_history := []
signal Marche
signal idle

func _process(delta: float) -> void:
	
	direction.x = Input.get_action_strength("droite") - Input.get_action_strength("gauche")
	direction.y = Input.get_action_strength("bas") - Input.get_action_strength("haut")
	
	velocity = direction.normalized() * speed
	cardinal_direction = direction
	
	if Input.is_action_pressed("haut") :
		haut = true
		#UpdateAnimation()
	if Input.is_action_pressed("bas") :
		bas = true
		#UpdateAnimation()
	if Input.is_action_pressed("droite") :
		droite = true
		#UpdateAnimation()
	if Input.is_action_pressed("gauche") :
		gauche = true
		#UpdateAnimation()
	if haut || bas || droite || gauche :
		state = ("Marche")
	
	
	if not Input.is_action_pressed("haut") :
		haut = false
	if not Input.is_action_pressed("bas") :
		bas = false
	if not Input.is_action_pressed("droite") :
		droite = false
	if not Input.is_action_pressed("gauche") :
		gauche = false
		
		
		
	if not haut and not bas and not droite and not gauche :
		state = ("idle")
	
	var targetAnim = state + "_" + AnimDirection()
	if targetAnim != currentAnim:
		animation_player.play(targetAnim)
		currentAnim = targetAnim
	emit_signal(state)
	
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	emit_signal(state)
	position_history.append(global_position)
	if position_history.size() > 100:
		position_history.pop_front()
	
func UpdateAnimation() -> void :
	animation_player.play (state + "_" + AnimDirection())
	
	
	
func AnimDirection() -> String:
	if direction == Vector2.ZERO :
		return LastDirection
	if abs(direction.x) > abs(direction.y) :
		if direction.x > 0 :
			LastDirection = "droite"
			return "droite"
		else :
			LastDirection = "gauche"
			return "gauche"
	else :
		if direction.y > 0 :
			LastDirection = "down"
			return "down"
		else :
			LastDirection = "up"
			return "up"
			
func _add_trail_point() -> void:
	var pos = global_position
#
