extends Control

@export var equipe : Array[Personnage]
@export var ennemis : Array[Ennemi]


# Les dialogues 
@onready var intro_dialogue : DialogueManager = $Dialogues/intro
@onready var battle_dialogue : DialogueManager = $Dialogues/battle


@onready var equipiers_container = $Equipiers
@onready var ennemis_container = $Ennemis

# Les boutons du HUD d'action
@onready var attaque_button : Button = $AttaqueButton
@onready var competence_button : Button = $"CompétencesButton"
@onready var items_button : Button = $ItemsButton
@onready var fuite_button : Button = $FuiteButton


## Les positions des ennemis à l'écran.
const ACTIVE_PLAYER_POS : Vector2 = Vector2(0,1088) 
const FIRST_EQUIPIER_POS : Vector2 = Vector2(-10,10)
const ENNEMI_POS : Vector2 = Vector2(800, 170)

signal game_turn       ## signal envoyé quand la main est donnée à l'ordi.
signal player_turn     ## signal envoyé quand la main est donnée au joueur.

## L'état du combat en cours. Soit c'est au joueur de jouer, soit c'est à l'ordi.
enum battle_state {
	GAME_TURN = 0, ## Etat quand le joueur n'a pas d'actions à faire. En gros, c'est quand y'a des dialogues, quoi.
	PLAYER_TURN = 1, ## Etat quand c'est au joueur de choisir ses actions.
}
var state : battle_state = battle_state.GAME_TURN


## Le joueur à qui c'est le tour de jouer. C'est celui situé à gauche de l'écran de combat. 
var active_player : Personnage
var active_player_node : ActivePlayer
@onready var active_player_scene : Resource = preload("res://Battle/ActivePlayer/active_player.tscn")


## Les equipiers, qui attendent leur tout. C'est ceux situé à droite de l'écran de combats.
var equipiers_nodes : Array[EquipierContainer]
@onready var equipier_scene : Resource = preload("res://Battle/EquipierContainer/Equipier_container.tscn")


## Les ennemis, à qui on va casser la gueule. Ils sont vraiment pas gentil dis donc.
@onready var ennemi_scene : Resource = preload("res://Battle/EnnemiContainer/enemy_container.tscn")
var ennemis_nodes : Array[EnnemiContainer]


func _ready() -> void:
	active_player = equipe[0]
	
	# Initialisation du HUD
	print("loading equipe")
	_load_player_actif()
	_load_equipiers()
	
	print("loading ennemis")
	_load_ennemis()
	
	
	# Début du FIGHT YAAAAAAAH
	game_turn.emit()
	intro_dialogue.lignes_de_dialogue[0].texte = "Un " + ennemis[0].name.to_upper() + " sauvage apparait !"
	
	intro_dialogue.start_dialogue()
	await intro_dialogue.dialogue_finished
	
	player_turn.emit()



""" =========== Fonctions pour initialiser le HUD =========== """

## Charge les caractéristiques du joueur actif dans la scène de combat. (initialise les barres de pv, les sprites etc.) 
func _load_player_actif():
	# 1. on load le joueur actif (le 1er dans la liste)
	active_player = equipe[0]
	
	active_player_node = active_player_scene.instantiate()
	get_tree().root.add_child.call_deferred(active_player_node)
	await active_player_node.ready
	
	active_player_node.load_personnage(active_player)
	active_player_node.position = ACTIVE_PLAYER_POS
	
	active_player_node.show()

## Charge les caractéristiques des équipiers dans la scène de combat (les place dans la scènes, affiche leur sprite et leur pc, etc.)
func _load_equipiers():
	# 2. On load les équipiers restants
	equipiers_nodes = []
	for i in range(1, len(equipe)):
		# Création de la node
		var e = await _create_equipier_container()
		
		# On setup la node comme il faut
		e.load_equipier(equipe[i])
		e.position = FIRST_EQUIPIER_POS + Vector2(0, 350*(i-1)) #Tous les equipiers sont a 300 pixels de distance
		
		# On ajoute la node dans la liste...
		equipiers_nodes.push_back(e)
		
		# ...et on l'affiche !
		e.show()


## Crée une instance d'EquipierContainer, la place dans la scène, et la renvoie. [br]
## Attention : La fonction est [b]asynchrone[/b] !!! (on oublie pas le await merci) 
func _create_equipier_container() -> EquipierContainer:
	var e : EquipierContainer = equipier_scene.instantiate()
	equipiers_container.add_child.call_deferred(e)
	await e.ready
	
	return e


## Charge les caractéristiques des ennemis dans la scène de combat. (les place dans la scène, affiche leur pv, etc.) 
func _load_ennemis():
	
	# Reset des ennemis (au cas où)
	ennemis_nodes = []
	
	# On commence par gérer 1 seul ennemi à la fois
	var e : EnnemiContainer = ennemi_scene.instantiate()
	ennemis_container.add_child.call_deferred(e)
	await e.ready
	
	e.load_ennemi(ennemis[0])
	e.position = ENNEMI_POS
	
	ennemis_nodes.push_back(e)
	
	e.show()


## Affiche le HUD des actions que peut faire le joueur. 
func _show_action_buttons():
	attaque_button.show()
	competence_button.show()
	items_button.show()
	fuite_button.show()


## Cache le HUD des actions que peut faire le joueur.
func _hide_action_buttons():
	attaque_button.hide()
	competence_button.hide()
	items_button.hide()
	fuite_button.hide()

""" ======================================================== """


""" =============== Les actions de combats================== """


## Le joueur actif attaque l'ennemi.
func attaquer(ennemi : EnnemiContainer):
	# Le joueur a fini de jouer, c'est au tour du jeu de prendre le relais
	game_turn.emit()
	
	var pv_ennemi = ennemi.pv_bar.value
	var pv_player = active_player.pv
	var atk_ennemi = ennemi.stats.damage
	var atk_player = active_player.arme.attaque

	battle_dialogue.lignes_de_dialogue[0].texte = active_player.nom + " attaque !"
	battle_dialogue.lignes_de_dialogue[1].texte = ennemi.stats.name + " prend " + str(atk_player) + " dégats !"
	battle_dialogue.lignes_de_dialogue[2].texte = ennemi.stats.name + " attaque !"
	battle_dialogue.lignes_de_dialogue[3].texte = active_player.nom + " prend " + str(atk_ennemi) + " dégats !"
	
	battle_dialogue.start_dialogue(2)
	await battle_dialogue.dialogue_stopped
	
	await get_tree().create_timer(0.1).timeout
	ennemi.set_pv(pv_ennemi - atk_player)
	
	print("on continue le dialogue")
	battle_dialogue.continue_dialogue(2)
	await battle_dialogue.dialogue_finished
	
	active_player.pv -= atk_ennemi
	active_player_node.set_pv(pv_player - atk_ennemi)
	
	#Fin du tour, c'est au nouveau joueur de jouer
	tour_suivant()


## Lance une compétence sur un ou plusieurs ennemis.
@warning_ignore("unused_parameter", "shadowed_variable")
func competence(comp : Competence, ennemis : Array[Ennemi]):
	pass
	#TODO


## Utilise un item sur un ou tous les personnages.
@warning_ignore("unused_parameter")
func use_item(item, personnage : Personnage):
	pass
	#TODO


""" ===================================================== """

""" ====================Trucs annexes===================="""

func _on_game_turn() -> void:
	state = battle_state.GAME_TURN
	_hide_action_buttons()

func _on_player_turn() -> void:
	state = battle_state.PLAYER_TURN
	_show_action_buttons()


func _on_attaque_button_pressed() -> void:
	attaquer(ennemis_nodes[0])




## Fonction à appeler quand les ennemid ont fini leur tour. [br]
## Effectue la rotation des personnages, change le personnage actif et notifie que c'est au tour du joueur. 
func tour_suivant():
	
	#1. Remettre l'ancien player actif dans les équipiers (en bas de la liste)
	var new_equipier = await _create_equipier_container()
	new_equipier.load_equipier(active_player)
	
	equipiers_nodes.push_back(new_equipier)
	
	#2. Changer de player actif
	var old_equipier : EquipierContainer = equipiers_nodes.pop_front()
	active_player = old_equipier.personnage
	active_player_node.load_personnage(active_player)
	old_equipier.queue_free()  #L'équipier est devenu le player actif, on le supprime de la scène
	
	
	#3. Replacer les équipiers correctement à l'écran
	for i in range(len(equipiers_nodes)):
		var e : EquipierContainer = equipiers_nodes[i]
		e.position = FIRST_EQUIPIER_POS + Vector2(0, 350*i)
	
	#4. C'est bon c'est de nouveau à nous de jouer ! 
	player_turn.emit()
