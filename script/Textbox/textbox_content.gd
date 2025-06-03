extends Resource
class_name TextboxContent

@export var texture : Texture
@export_multiline var texte : String

# TextboxManager : general_font

#Font
#Custom font
#Font color
#Font size


@export_group("Avancé") 
@export_range(1,500, 1, "or_greater") var vitesse_défilement_texte : float = 100
@export_flags("Inskipable:1", "Autoskip:2") var skip_options : int = 0 
