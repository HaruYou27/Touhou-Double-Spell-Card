extends Control

onready var back :BackButton = $back
onready var tabcontainer :TabContainer = $TabContainer
onready var save := Global.save_data

func _ready() -> void:
	AudioServer.set_bus_volume_db(2, -80)
	
	#Audio
	master_slider.value = save.master_db
	bgm_slider.value = save.bgm_db
	sfx_slider.value = save.sfx_db
	
	#Controls
	auto_shoot.pressed = save.auto_shoot
	mouse.pressed = save.use_mouse
	var i := 0
	for value in save.key_bind.values():
		keybind[i].update_label(OS.get_scancode_string(value))
		i += 1
	
	#Assist mode
	assist_toggler.pressed = save.assist_mode
	bomb.text = str(save.init_bomb)
	death_timer.text = str(save.death_time)
	
	AudioServer.set_bus_volume_db(2, 0)
	
func _exit_tree() -> void:
	save.death_time = float(death_timer.text)
	save.init_bomb = int(bomb.text)
	save.save()

func _entered() -> void:
	show()
	back.disabled = false
	tabcontainer.set_process_input(true)
	$TabContainer/Graphic/settings/fullscreen.grab_focus()
	
func _on_back_pressed():
	tabcontainer.set_process_input(false)
	


#Audio
onready var master_slider :AnimatedHSlider = $TabContainer/Audio/master
onready var bgm_slider :AnimatedHSlider = $TabContainer/Audio/bgm
onready var sfx_slider :AnimatedHSlider = $TabContainer/Audio/sfx

func _on_audio_reset_pressed():
	master_slider.value = 0.0
	bgm_slider.value = 0.0
	sfx_slider.value = 0.0

func _on_master_value_changed(value):
	save.master_db = value

func _on_bgm_value_changed(value):
	save.bgm_db = value

func _on_sfx_value_changed(value):
	save.sfx_db = value

#Assist mode
onready var assist_toggler :AnimatedTextButton = $"TabContainer/Assist mode/cheat"
onready var death_timer :LineEdit = $"TabContainer/Assist mode/deathtimer"
onready var bomb :LineEdit = $"TabContainer/Assist mode/bomb"

func _on_assist_reset_pressed():
	AudioServer.set_bus_volume_db(2, -80)
	assist_toggler.pressed = false
	AudioServer.set_bus_volume_db(2, 0)
	death_timer.text = '1.0'
	bomb.text = '3'

func _on_cheat_toggled(button_pressed):
	save.assist_mode = button_pressed
	if button_pressed:
		$Popup/CheatWarn.popup()

#Controls
onready var auto_shoot :AnimatedTextButton = $TabContainer/Control/autoshoot
onready var mouse : AnimatedButton = $TabContainer/Control/mouse
onready var keybind := [
	$TabContainer/Control/left,
	$TabContainer/Control/right,
	$TabContainer/Control/up,
	$TabContainer/Control/down,
	$TabContainer/Control/focus,
	$TabContainer/Control/shoot,
	$TabContainer/Control/bomb
]

func _on_controls_reset_pressed():
	save.key_bind = {
	'ui_left' : KEY_LEFT,
	'ui_right' : KEY_RIGHT,
	'ui_up' : KEY_UP,
	'ui_down' : KEY_DOWN,
	'focus' : KEY_SHIFT,
	'shoot' : KEY_Z,
	'bomb' : KEY_X
}
	var i := 0
	for key in save.key_bind.keys():
		var value = save.key_bind[key]
		keybind[i].update_label(OS.get_scancode_string(value))
		InputMap.action_erase_events(key)
		var event = InputEventKey.new()
		event.scancode = value
		InputMap.action_add_event(key, event)
		i += 1
	
	AudioServer.set_bus_volume_db(2, -80)
	auto_shoot.pressed = true
	mouse.pressed = true
	AudioServer.set_bus_volume_db(2, 0)

func _on_autoshoot_toggled(button_pressed):
	save.auto_shoot = button_pressed
	keybind[5].disabled = button_pressed

func _on_mouse_toggled(button_pressed):
	auto_shoot.disabled = button_pressed
	for button in keybind.slice(0, 4):
		button.disabled = button_pressed
		
	save.use_mouse = button_pressed
