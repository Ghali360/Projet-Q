class_name player
extends CharacterBody2D

@export var speed : float = 200
@export var timerAnim : float = 0.250
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
var Vitesse : float 
var canMove : bool =true
var obstacle_direction : Vector2 = Vector2.ZERO


signal Marche
signal idle
signal Moving
signal NotMoving

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Collision")
	if  not body.is_in_group("Compagnon"):
		canMove = false
		obstacle_direction = (body.global_position - global_position).normalized()
		print(canMove)

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("NotCollision")
	if not body.is_in_group("Compagnon"):
		canMove = true
		obstacle_direction = Vector2.ZERO
		print(canMove)
func _process(delta: float) -> void:
	if timerAnim >= 0 :
		timerAnim -= delta
	if canMove:
		direction.x = Input.get_action_strength("droite") - Input.get_action_strength("gauche")
		direction.y = Input.get_action_strength("bas") - Input.get_action_strength("haut")
	else :
		var raw_input = Vector2(
			Input.get_action_strength("droite") - Input.get_action_strength("gauche"),
			Input.get_action_strength("bas") - Input.get_action_strength("haut"))
		
		if obstacle_direction != Vector2.ZERO:
			var dot_product = obstacle_direction.dot(raw_input.normalized())
			
			# Autoriser seulement les mouvements à plus de 90° de l'obstacle
			if dot_product > 0.7:
				# Bloquer complètement le mouvement vers l'obstacle
				var blocked_component = obstacle_direction * dot_product
				raw_input -= blocked_component * raw_input.length()
		direction = raw_input
			
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
	
	var move_direction = direction.normalized() if direction.length() > 0 else Vector2.ZERO
	move_and_slide()
	emit_signal("Moving")
	emit_signal(state)
	Vitesse = velocity.length()
	#position_history.append(global_position)
	if !canMove && get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		velocity += collision.get_normal() * 5 
	
func UpdateAnimation() -> void :
	animation_player.play (state + "_" + AnimDirection())
	
	
	
func AnimDirection() -> String:
	if direction == Vector2.ZERO :
		return LastDirection
	if abs(direction.x) > abs(direction.y) :
		if direction.x > 0 and timerAnim <= 0  :
			LastDirection = "droite"
			timerAnim = 0.15
			return "droite"
		elif direction.x < 0 and timerAnim <= 0 :
			LastDirection = "gauche"
			timerAnim = 0.15
			return "gauche"
	else :
		if direction.y > 0 and timerAnim <= 0 :
			LastDirection = "down"
			timerAnim = 0.15
			return "down"
		elif direction.y < 0 and timerAnim <= 0 :
			LastDirection = "up"
			timerAnim = 0.15
			return "up"
	return LastDirection

func _add_trail_point() -> void:
	var pos = global_position
#
