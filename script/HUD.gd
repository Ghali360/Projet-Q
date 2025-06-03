extends Node

var panel : Panel #ee

signal textbox_closed

# Affiche un bulle de dialogue. Il faut cliquer pour la faire disparaitre. 
func display_text(text : string, font : FontFile) -> void:
	
