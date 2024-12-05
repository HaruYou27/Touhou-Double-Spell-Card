extends VBoxContainer

@onready var user_data :UserData = Global.user_data
@onready var vulkan: CheckBox = $vulkan
@onready var particles: Slider = $Particles
@onready var effect_level: OptionButton = $EffectLevel

func _ready() -> void:
	particles.value = user_data.particle_amount
	effect_level.select(user_data.graphic_level)
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "mobile":
		vulkan.button_pressed = true

func _exit_tree() -> void:
	if vulkan.button_pressed:
		ProjectSettings.set_setting("rendering/renderer/rendering_method", "mobile")
		ProjectSettings.set_setting("rendering/renderer/rendering_method.mobile", "mobile")
	else:
		ProjectSettings.set_setting("rendering/renderer/rendering_method", "gl_compatibility")
		ProjectSettings.set_setting("rendering/renderer/rendering_method.mobile", "gl_compatibility")
		
	user_data.particle_amount = particles.value
	user_data.graphic_level = effect_level.selected

func _on_reset_pressed() -> void:
	particles.value = 1.0
	effect_level.select(3)
	vulkan.button_pressed = false
	
