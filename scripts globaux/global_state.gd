extends Node

# Données du joueur
var player_stats = {
	"health": 100,
	"max_health": 100,
	"attack": 15,
	"defense": 10
}

var player_inventory = ["épée_rouillée", "potion_santé"]

# Positions sauvegardées par scène
var saved_positions = {}

# Données des compagnons
var compagnons = []

func save_game():
	# Créer une copie sécurisée des données
	var save_data = {
		"stats": player_stats.duplicate(),
		"inventory": player_inventory.duplicate(),
		"positions": saved_positions.duplicate(),
		"companions": []  # On initialise toujours la liste
	}
	
	# Ajouter les compagnons s'ils existent
	for compagnon in compagnons:
		save_data["companions"].append({
			"scene_path": compagnon["scene_path"],
			"position": compagnon["position"],
			"state": compagnon["state"].duplicate() if compagnon.has("state") else {}
		})
	
	# Sauvegarder dans un fichier
	var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		print("Sauvegarde réussie!")
	else:
		push_error("Erreur d'écriture du fichier de sauvegarde")

func load_game():
	if !FileAccess.file_exists("user://save.dat"):
		return false
	
	# Charger les données brutes
	var file = FileAccess.open("user://save.dat", FileAccess.READ)
	if !file:
		push_error("Erreur de lecture du fichier de sauvegarde")
		return false
	
	var save_data = file.get_var()
	if save_data == null:
		push_error("Données de sauvegarde corrompues")
		return false
	
	# Charger avec des valeurs par défaut si les clés manquent
	player_stats = save_data.get("stats", {"health": 100, "max_health": 100})
	player_inventory = save_data.get("inventory", ["épée_rouillée", "potion_santé"])
	saved_positions = save_data.get("positions", {})
	
	# Gestion spécifique des compagnons
	compagnons.clear()
	if save_data.has("companions"):
		compagnons = save_data["companions"]
	
	print("Chargement réussi! Compagnons: ", compagnons.size())
	return true

func save_position(scene_name: String, position: Vector2):
	saved_positions[scene_name] = position
	print("Position sauvegardée pour ", scene_name, ": ", position)

func save_companions(companion_nodes: Array):
	compagnons.clear()
	for companion in companion_nodes:
		# Vérifier que le compagnon est valide
		if is_instance_valid(companion):
			compagnons.append({
				"scene_path": companion.scene_file_path,
				"position": companion.global_position,
				"state": companion.get_state() if companion.has_method("get_state") else {}
			})

func load_companions(parent_node: Node):
	if !parent_node:
		push_error("Parent node invalide pour charger les compagnons")
		return
	
	for data in compagnons:
		if ResourceLoader.exists(data["scene_path"]):
			var companion = load(data["scene_path"]).instantiate()
			companion.global_position = data.get("position", Vector2.ZERO)
			
			# Restaurer l'état si possible
			if companion.has_method("set_state") && data.has("state"):
				companion.set_state(data["state"])
			
			parent_node.add_child(companion)
	
	# Ne pas vider les données pour permettre plusieurs chargements
	# companions.clear()  # Retiré pour éviter les problèmes

func load_position(scene_name: String, default: Vector2) -> Vector2:
	return saved_positions.get(scene_name, default)
