extends Resource
class_name Personnage
## Un personnage ou un pnj.

@export var nom : String
@export var sprite : Texture 
@export var pv_max : int
@export var mana_max : int
@export var defense : int

@export var pv : int
@export var mana : int

@export var arme : Arme
