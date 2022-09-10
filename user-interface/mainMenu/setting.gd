extends Control

onready var back :BackButton = $back
onready var tabcontainer :TabContainer = $TabContainer

var templates := {}

func _ready() -> void:
	#Graphic
	AudioServer.set_bus_volume_db(2, -80)
	vsync.pressed = Global.save_data.vsync
	fullscreen.pressed = Global.save_data.fullscreen
	borderless.pressed = Global.save_data.borderless
	resolution.item = resolution.items.find(Global.save_data.resolution)
	fps.item = fps.items.find(Global.save_data.target_fps)
	
	#Audio
	master_slider.value = Global.save_data.master_db
	bgm_slider.value = Global.save_data.bgm_db
	sfx_slider.value = Global.save_data.sfx_db
	
	#Controls
	auto_shoot.pressed = Global.save_data.auto_shoot
	mouse.pressed = Global.save_data.use_mouse
	
	templates['ui_left'] = left.text
	templates['ui_right'] = right.text
	templates['ui_up'] = up.text
	templates['ui_down'] = down.text
	templates['focus'] = focus.text
	templates['bomb'] = bomb.text
	templates['shoot'] = shooting.text
	left.text = left.text % OS.get_scancode_string(Global.save_data.left)
	right.text = right.text % OS.get_scancode_string(Global.save_data.right)
	down.text = down.text % OS.get_scancode_string(Global.save_data.down)
	up.text = up.text % OS.get_scancode_string(Global.save_data.up)
	focus.text = focus.text % OS.get_scancode_string(Global.save_data.focus)
	shooting.text = shooting.text % OS.get_scancode_string(Global.save_data.shoot)
	bomb.text = bomb.text % OS.get_scancode_string(Global.save_data.bomb)
	
	#Assist mode
	assist_toggler.pressed = Global.save_data.assist_mode
	
	AudioServer.set_bus_volume_db(2, 0)
	
func _exit_tree() -> void:
	Global.save_data.save()

func _entered() -> void:
	back.disabled = false
	tabcontainer.set_process_input(true)
	fullscreen.grab_focus()
	
func _on_back_pressed():
	tabcontainer.set_process_input(false)
	
func _on_graphic_reset_pressed():
	AudioServer.set_bus_volume_db(2, -80)
	fps.item = 1
	resolution.item = 1
	AudioServer.set_bus_volume_db(2, -80)
	vsync.pressed = false
	fullscreen.pressed = false
	borderless.pressed = false
	AudioServer.set_bus_volume_db(2, 0)
	AudioServer.set_bus_volume_db(2, 0)

#Graphic
onready var fps :ScrollButton = $TabContainer/Graphic/GridContainer/fps
onready var resolution :ScrollButton = $TabContainer/Graphic/GridContainer/resolution
onready var fullscreen :AnimatedTextButton = $TabContainer/Graphic/fullscreen
onready var borderless :AnimatedTextButton = $TabContainer/Graphic/borderless
onready var vsync :AnimatedTextButton = $TabContainer/Graphic/vsync

func _on_vsync_toggled(button_pressed):
	Global.save_data.vsync = button_pressed

func _on_fullscreen_toggled(button_pressed):
	Global.save_data.fullscreen = button_pressed
	resolution.disabled = button_pressed

func _on_borderless_toggled(button_pressed):
	Global.save_data.borderless = button_pressed

func _on_resolution_item_changed(item):
	Global.save_data.resolution = resolution.get_item()

func _on_fps_item_changed(item):
	Global.save_data.target_fps = fps.get_item()

#Audio
onready var master_slider :AnimatedHSlider = $TabContainer/Audio/master
onready var bgm_slider :AnimatedHSlider = $TabContainer/Audio/bgm
onready var sfx_slider :AnimatedHSlider = $TabContainer/Audio/sfx

func _on_audio_reset_pressed():
	master_slider.value = 0.0
	bgm_slider.value = 0.0
	sfx_slider.value = 0.0

func _on_master_value_changed(value):
	Global.save_data.master_db = value

func _on_bgm_value_changed(value):
	Global.save_data.bgm_db = value

func _on_sfx_value_changed(value):
	Global.save_data.sfx_db = value

#Assist mode
onready var assist_toggler :AnimatedTextButton = $"TabContainer/Assist mode/cheat"

func _on_assist_reset_pressed():
	AudioServer.set_bus_volume_db(2, -80)
	assist_toggler.pressed = false
	AudioServer.set_bus_volume_db(2, 0)

func _on_cheat_toggled(button_pressed):
	Global.save_data.assist_mode = button_pressed

#Controls
onready var auto_shoot :AnimatedTextButton = $TabContainer/Control/autoshoot
onready var shooting :AnimatedTextButton = $TabContainer/Control/shooting
onready var mouse :AnimatedTextButton = $TabContainer/Control/mouse
onready var left :AnimatedTextButton = $TabContainer/Control/left
onready var right :AnimatedTextButton = $TabContainer/Control/right
onready var up :AnimatedTextButton = $TabContainer/Control/up
onready var down :AnimatedTextButton = $TabContainer/Control/down
onready var focus :AnimatedTextButton = $TabContainer/Control/focus
onready var bomb :AnimatedTextButton = $TabContainer/Control/bomb

func _on_controls_reset_pressed():
	left.text = templates['ui_left'] % 'Left'
	right.text = templates['ui_right'] % 'Right'
	up.text = templates['ui_up'] % 'Up'
	down.text = templates['ui_down'] % 'Down'
	focus.text = templates['ui_left'] % 'Shift'
	bomb.text = templates['bomb'] % 'X'
	shooting.text = templates['shoot'] % 'Z'
	Global.save_data.left = KEY_LEFT
	Global.save_data.right = KEY_RIGHT
	Global.save_data.up = KEY_UP
	Global.save_data.down = KEY_DOWN
	Global.save_data.focus = KEY_SHIFT
	Global.save_data.bomb = KEY_X
	Global.save_data.shoot = KEY_Z
	
	AudioServer.set_bus_volume_db(2, -80)
	auto_shoot.pressed = true
	mouse.pressed = false
	AudioServer.set_bus_volume_db(2, 0)

func _on_autoshoot_toggled(button_pressed):
	Global.save_data.auto_shoot = button_pressed

func _on_mouse_toggled(button_pressed):
	left.disabled = not button_pressed
	right.disabled = not button_pressed
	up.disabled = not button_pressed
	down.disabled = not button_pressed
	Global.save_data.use_mouse = button_pressed
