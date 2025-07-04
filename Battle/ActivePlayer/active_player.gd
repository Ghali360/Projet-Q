extends Node2D
class_name ActivePlayer

@onready var pv_bar : ProgressBar = $pvBar
@onready var mana_bar : ProgressBar = $manaBar
@onready var sprite : Sprite2D = $MeshInstance2D/Sprite2D

@onready var pv_label : Label = $pvBar/MarginContainer/Label
@onready var mana_label : Label = $manaBar/MarginContainer/Label

"""Setter pour la barre de mana et de pv"""
func init_pv_bar(pv_actuel : int, pv_max : int):
	pv_bar.max_value = pv_max
	pv_bar.value = pv_actuel
	
	pv_label.text = str(pv_actuel)

func init_mana_bar(mana_actuel : int, mana_max : int):
	mana_bar.max_value = mana_max
	mana_bar.value = mana_actuel
	
	mana_label.text = str(mana_actuel)

func set_pv(pv : int):
	pv_bar.value = pv
	pv_label.text = str(pv)

func set_mana(mana : int):
	mana_bar.value = mana
	mana_label.text = str(mana)

## Charge toute les données du personnage dans la scene.
func load_personnage(personnage : Personnage):
	init_mana_bar(personnage.mana, personnage.mana_max)
	init_pv_bar(personnage.pv, personnage.pv_max)
	
	sprite.texture = personnage.sprite
