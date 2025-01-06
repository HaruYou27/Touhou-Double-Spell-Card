extends VBoxContainer

@onready var user_data :UserData = Global.user_data
@onready var particles: Slider = $Particles
@onready var effect_level: OptionButton = $EffectLevel

func _ready() -> void:
	particles.value = user_data.particle_amount
	effect_level.select(user_data.graphic_level)

func _exit_tree() -> void:
	user_data.particle_amount = particles.value
	user_data.graphic_level = effect_level.selected

func _on_reset_pressed() -> void:
	particles.value = 1.0
	effect_level.select(3)
