extends VBoxContainer

onready var bgm :HSlider = $bgm
onready var bgmLabel :FormatLabel = $BgmLabel
onready var mute_bgm :Button = $muteBGM
onready var sfx :HSlider = $sfx
onready var sfxLabel :FormatLabel = $SfxLabel
onready var mute_sfx :Button = $muteSFX

func _ready():
	var config :AudioBusLayout = load('user://audio_override.res')
	if config:
		AudioServer.set_bus_layout(config)
	
	mute_sfx.pressed = AudioServer.is_bus_mute(1)
	mute_bgm.pressed = AudioServer.is_bus_mute(2)
	
	sfx.value = AudioServer.get_bus_volume_db(1)
	bgm.value = AudioServer.get_bus_volume_db(2)

static func get_percentage(value:float):
	return (value + 60) / 60 * 100

func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	sfxLabel.update_label(get_percentage(value))

func _on_bgm_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	bgmLabel.update_label(get_percentage(value))

func _exit_tree():
	if not Engine.editor_hint:
		ResourceSaver.save('user://audio_override.res', AudioServer.generate_bus_layout())

func _on_muteBGM_toggled(button_pressed):
	AudioServer.set_bus_mute(2, button_pressed)
	bgm.editable = button_pressed

func _on_audio_reset_pressed():
	bgm.value = 0.0
	sfx.value = 0.0
	mute_bgm.pressed = false
	mute_sfx.pressed = false

func _on_muteSFX_toggled(button_pressed):
	AudioServer.set_bus_mute(1, button_pressed)
	sfx.editable = button_pressed
