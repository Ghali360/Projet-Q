extends VBoxContainer
class_name EnnemiContainer

@onready var pv_bar : ProgressBar = $ProgressBar
@onready var sprite : TextureRect = $Enemy

@onready var pv_label : Label = $ProgressBar/Label

var stats : Ennemi

"""Setters pour update les barre de pv et de mana"""
func init_pv_bar(pv_max : int):
	pv_bar.max_value = pv_max
	pv_bar.value = pv_max
	
	pv_label.text = str(pv_max)

func set_pv(pv):
	pv_bar.value = pv
	pv_label.text = str(pv)


func load_ennemi(ennemi : Ennemi):
	stats = ennemi
	init_pv_bar(ennemi.pv)
	pv_label.text = str(ennemi.pv)
	
	sprite.texture = ennemi.texture
