tool
extends FocusedBoxcontainer

onready var bgm_slider :HSlider = $bgm
onready var mute_bgm :Button = $muteBGM
onready var sfx_slider :HSlider = $sfx
onready var mute_sfx :Button = $muteSFX

func _ready():
	var config :AudioBusLayout = load('user://audio_override.res')
	if config:
		AudioServer.set_bus_layout(config)
	
	mute_sfx.pressed = AudioServer.is_bus_mute(1)
	mute_bgm.pressed = AudioServer.is_bus_mute(2)
	sfx_slider.value = AudioServer.get_bus_volume_db(1)
	bgm_slider.value = AudioServer.get_bus_volume_db(2)

func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)

func _on_bgm_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)

func _exit_tree():
	if not Engine.editor_hint:
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
