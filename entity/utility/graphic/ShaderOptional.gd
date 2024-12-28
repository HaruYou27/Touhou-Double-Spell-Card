extends GraphicOptional
class_name ShaderOptional

@export var material_low : ShaderMaterial
@export var material_medium : ShaderMaterial
@export var material_high : ShaderMaterial
@export var material_ultra : ShaderMaterial

func _ready() -> void:
	change_graphic()
	Global.update_graphic.connect(change_graphic)
	
func change_graphic() -> void:
	match Global.user_data.graphic_level:
		UserData.GRAPHIC_LEVEL.ULTRA:
			material = material_ultra
		UserData.GRAPHIC_LEVEL.HIGH:
			material = material_high
		UserData.GRAPHIC_LEVEL.MEDIUM:
			material = material_medium
		UserData.GRAPHIC_LEVEL.LOW:
			material = material_low
		UserData.GRAPHIC_LEVEL.MINIMAL:
			hide()
