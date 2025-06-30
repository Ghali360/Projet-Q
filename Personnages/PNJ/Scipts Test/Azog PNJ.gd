extends StaticBody2D

@onready var interactible: Area2D = $Interactible
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	interactible.interact = _on_interact
	
func _on_interact():
	if sprite_2d.frame == 0:
		sprite_2d.frame = 1
		interactible.is_interactif = false
		print("Azog touché")
		await flash()
		
func flash():
	var mat := sprite_2d.material
	if mat is ShaderMaterial :
		mat.set_shader_parameter("flash_modifier", 0.65)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("flash_modifier", 0)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("flash_modifier", 0.65)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("flash_modifier", 0)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("flash_modifier", 0.65)
		await get_tree().create_timer(0.1).timeout
		mat.set_shader_parameter("flash_modifier", 0)
		interactible.is_interactif = true
