extends Node2D

var membre

func _ready() -> void:
	trier_membres()
	
	for i in range (1, get_child_count()):
		membre = get_child(i)
		var cible = get_child(i-1)
		membre.cible_suivi = cible
		
func trier_membres():
	var player = $player
	remove_child(player)
	add_child(player)
	move_child(player, 0)
	
	membre = get_children()
