extends CharacterBody2D
class_name CompagnonSecondaire

const NbrPointMax : int = 7

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var root = get_tree().get_current_scene()
@export var speed := 200
@export var timerAnim : float = 0.250
var FriendBoss: CharacterBody2D
var Friend: CharacterBody2D
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
var  HasFriend : bool 
var hasFriendBoss : bool = false
var is_ready := false
var player : CharacterBody2D
var friendNBR
signal Moving
signal NotMoving

func _ready() -> void:
	call_deferred("AssingPlayer")
	call_deferred("_Check_Friend")
	is_ready = true
func AssingPlayer():
	friendNBR = name.to_int() - 1
	FriendBoss = root.find_child("Compagnon "+str(friendNBR))
	player = root.find_child("player")
	print(FriendBoss)
	if FriendBoss == null:
		pass
	else : 
		hasFriendBoss = true
	player_trail = FriendBoss.get_child(4)
	if player_trail == null :
		print("NoTRAIL")
	else :
		print("Trail")
	if FriendBoss == null:
			pass
	else : 
		hasFriendBoss = true
	if player == null:
		pass
	else : 
		global_position = player.global_position
		
func _Check_Friend():
	var friendNBR = name.to_int() + 1
	Friend = root.find_child("Compagnon "+str(friendNBR))
	if Friend == null :
		HasFriend = false
	else :
		HasFriend = true

func _process(delta: float) -> void:
	if timerAnim >= 0 :
		timerAnim -= delta
	_get_animation_direction(velocity)

func _physics_process(delta: float) -> void:
	if FriendBoss != null :
		if FriendBoss.global_position.y >= global_position.y :
			z_index = FriendBoss.z_index - 1
		else :
			z_index = FriendBoss.z_index + 1
	if hasFriendBoss:
		var player_global_position = FriendBoss.global_position
		if player_trail != null:
			var distance = global_position.distance_to(player_global_position)
			if player_trail.points.size() >= NbrPointMax:
				if HasFriend:
					emit_signal("Moving")
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
				emit_signal("NotMoving")
				state = ("idle")
				animation_player.stop()
				animation_player.play("idle_" + direction)

func _get_animation_direction(vel: Vector2) -> String:
	if vel == Vector2.ZERO:
		return last_direction  # Garde la dernière direction connue
	if abs(vel.x) > abs(vel.y) and timerAnim <= 0:
		if vel.x > 0 and timerAnim <= 0:
			direction = "droite"
			timerAnim = 0.15
		elif vel.x < 0 and timerAnim <= 0:
			direction = "gauche"
			timerAnim = 0.15
	else:
		if vel.y > 0 and timerAnim <= 0:
			direction = "down"
			timerAnim = 0.15
		elif vel.y < 0 and timerAnim <= 0:
			direction = "up"
			timerAnim = 0.15
	return direction
