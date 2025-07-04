extends Node2D
class_name EquipierContainer

@onready var pv_bar : ProgressBar = $pvBar
@onready var mana_bar : ProgressBar = $manaBar
@onready var sprite : Sprite2D = $MeshInstance2D/Sprite2D

@onready var pv_label : Label = $pvBar/MarginContainer/Label
@onready var mana_label : Label = $manaBar/MarginContainer/Label

"""Setters pour update les barre de pv et de mana"""

func init_pv_bar(pv_actuel, pv_max):
	pv_bar.max_value = pv_max
	pv_bar.value = pv_actuel
	
	pv_label.text = str(pv_actuel)

func init_mana_bar(mana_actuel, mana_max):
	mana_bar.max_value = mana_max
	mana_bar.value = mana_actuel

	mana_label.text = str(mana_actuel)

func set_pv(pv):
	pv_bar.value = pv
	pv_label.text = str(pv)

func set_mana(mana):
	mana_bar.value = mana
	mana_label.text = str(mana)


## Charge les données du personnage dans la scène, et affiche tout bien correctement.
func load_equipier(equipier : Personnage):
	init_mana_bar(equipier.mana, equipier.mana_max)
	init_pv_bar(equipier.pv, equipier.pv_max)
	
	sprite.texture = equipier.sprite
