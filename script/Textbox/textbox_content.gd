@tool
extends Resource
class_name TextboxContent

@export var texture : Texture
@export_multiline var texte : String


# general_font
# general_font_color

#Custom font --> si activé:
	#Font
	#Font color
	#Font size



@export_group("Avancé") 
@export_range(1,500, 1, "or_greater") var vitesse_défilement_texte : float = 100
@export_flags("Inskipable:1", "Autoskip:2") var skip_options : int = 0 

@export_group("Font")
@export var font_custom : bool = false:
	set(param):
		font_custom = param
		notify_property_list_changed()

# Paramètres optionnels, accessibles si police_custom est mis à true.
var font : Font = null
var font_color : Color = Color.BLACK
var font_size : int = 30



"""=============  PARAMETRES CACHÉS  ===================="""
"""===========  (ouuuuuuu c mystérieu)  ================="""
"""Inutile pour l'instant """

func _get_property_list() -> Array[Dictionary]:
	var ret : Array[Dictionary] = []
	if font_custom:
		ret.append({
			"name" : &"font",
			"type" : TYPE_OBJECT, #Font
			"hint" : PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "Font",
			#"usage" : PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR,
		})

		ret.append({
			"name" : &"font_color",
			"type" : TYPE_COLOR,
			#"usage" : PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR,
		})

		ret.append({
			"name" : &"font_size",
			"type" : TYPE_INT, #Font
			"hint" : PROPERTY_HINT_RANGE,
			"hint_string" : "1,100,1,or_greater",
			#"usage" : PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR,
		})
	return ret

func _get(property: StringName) -> Variant:
	if property == "font":
		return font
	elif property == "font_color":
		return font_color
	elif property == "font_size":
		return font_size
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property == "font":
		font = value
		return true
	elif property == "font_color":
		font_color = value
		return true
	elif property == "font_size":
		font_size = value
		return true
		
	return false


func test():
	print( get_script().get_script_property_list() )
