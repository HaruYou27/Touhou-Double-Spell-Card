extends GraphicOptional
class_name ShaderOptional

@export var material_low : ShaderMaterial
@export var material_medium : ShaderMaterial
@export var material_high : ShaderMaterial

func _ready() -> void:
	match graphic_level:
		3:
			material = material_high
		2:
			material = material_medium
		1:
			material = material_high
		0:
			hide()
	
