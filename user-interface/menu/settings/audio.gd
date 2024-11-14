extends VBoxContainer

func _ready() -> void:
	var user_data :AudioBusLayout = load('user://audio_override.res')
	if user_data:
		AudioServer.set_bus_layout(user_data)
		#print_debug('override')
		
	sfx.value = AudioServer.get_bus_volume_db(1)
	bgm.value = AudioServer.get_bus_volume_db(2)
	voice.value = AudioServer.get_bus_volume_db(3)
	mic.value = AudioServer.get_bus_volume_db(4)

@onready var sfx :HSlider = $sfx
func _on_sfx_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(1, value)

@onready var bgm :HSlider = $bgm
func _on_bgm_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(2, value)

@onready var voice := $voice
func _on_voice_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(3, value)
	
@onready var mic := $mic
func _on_mic_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(4, value)

@onready var master := $master
func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _exit_tree() -> void:
	if not Engine.is_editor_hint():
		ResourceSaver.save(AudioServer.generate_bus_layout(), 'user://audio_override.res')

func _on_reset_pressed():
	bgm.value = .0
	sfx.value = .0
	voice.value = .0
	mic.value = .0
	master.value = 0.0
