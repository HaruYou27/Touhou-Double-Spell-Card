extends ShaderOptional
class_name ShaderOptionalVulkan

@export var material_low_vulkan : ShaderMaterial
@export var material_medium_vulkan : ShaderMaterial
@export var material_high_vulkan : ShaderMaterial
@export var material_ultra_vulkan : ShaderMaterial

func change_graphic() -> void:
	if ProjectSettings.get_setting("rendering/renderer/rendering_method.mobile") == "gl_compatibility":
		super()
		return
		
	match Global.user_data.graphic_level:
		UserData.GRAPHIC_LEVEL.ULTRA:
			material = material_ultra_vulkan
		UserData.GRAPHIC_LEVEL.HIGH:
			material = material_high_vulkan
		UserData.GRAPHIC_LEVEL.MEDIUM:
			material = material_medium_vulkan
		UserData.GRAPHIC_LEVEL.LOW:
			material = material_low_vulkan
		UserData.GRAPHIC_LEVEL.MINIMAL:
			hide()
