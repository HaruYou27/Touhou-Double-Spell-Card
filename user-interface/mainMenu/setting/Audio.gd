extends VBoxContainer

onready var bgm_slider :AnimatedHSlider = $bgm
onready var sfx_slider :AnimatedHSlider = $sfx

func _ready():
	var config :AudioBusLayout = load('user://audio_override.res')
	if config:
		AudioServer.set_bus_layout(config)
	
	sfx_slider.value = AudioServer.get_bus_volume_db(1)
	bgm_slider.value = AudioServer.get_bus_volume_db(2)
	get_parent().first_button.append(sfx_slider)

func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)

func _on_bgm_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)

func _exit_tree():
	ResourceSaver.save('user://audio_override.res', AudioServer.generate_bus_layout())

func _on_muteBGM_toggled(button_pressed):
	AudioServer.set_bus_mute(2, button_pressed)
	bgm_slider.editable = button_pressed

func _on_audio_reset_pressed():
	bgm_slider.value = 0.0
	sfx_slider.value = 0.0

func _on_muteSFX_toggled(button_pressed):
	AudioServer.set_bus_mute(1, button_pressed)
	sfx_slider.editable = button_pressed
