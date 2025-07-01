extends CanvasLayer
func _ready():
	var background = ColorRect.new()
	background.color = Color(1, 1, 1)  # Couleur de fond si la texture est transparente
	background.size = get_viewport_rect().size
	
	# Créez un StyleBoxTexture
	var style = StyleBoxTexture.new()
	style.texture = preload("res://art/background.png")
	style.expand_margin_left = 0
	style.expand_margin_right = 0
	style.expand_margin_top = 0
	style.expand_margin_bottom = 0
	
	background.set("custom_styles/panel", style)
	background.z_index = -20
	add_child(background)
