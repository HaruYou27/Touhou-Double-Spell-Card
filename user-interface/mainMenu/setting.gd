extends Control

onready var fps :OptionButton = $TabContainer/Graphic/fps
onready var resolution :OptionButton = $TabContainer/Graphic/resolution

onready var back :BackButton = $back
onready var tabcontainer :TabContainer = $TabContainer

func _ready() -> void:
	AudioServer.set_bus_volume_db(2, -80)
	$TabContainer/Graphic/vsync.pressed = Global.save_data.vsync
	fps.sel
	AudioServer.set_bus_volume_db(2, 0)

func _on_settings_pressed():
	back.disabled = false
	
func _on_reset_pressed():
	var tab = tabcontainer.current_tab
	match tab:
		0:
			AudioServer.set_bus_volume_db(2, -80)
			$TabContainer/Graphic/vsync.pressed = false
			fps.selected = 2
			resolution.selected = 1
			$TabContainer/Graphic/fullscreen.pressed = false
			$TabContainer/Graphic/borderless.pressed = false
			$TabContainer/Graphic/shake.pressed = true
			$TabContainer/Graphic/flash.pressed = true
			AudioServer.set_bus_volume_db(2, 0)

#Graphic
func _on_vsync_toggled(button_pressed):
	Global.save_data.vsync = button_pressed
	if button_pressed:
		fps.disable = true
	else:
		fps.disable = false

func _on_flash_toggled(button_pressed):
	Global.save_data.screen_flash = button_pressed

func _on_shake_toggled(button_pressed):
	Global.save_data.screen_shake = button_pressed

func _on_autoshoot_toggled(button_pressed):
	Global.save_data.auto_shoot = button_pressed

func _on_fullscreen_toggled(button_pressed):
	Global.save_data.fullscreen = button_pressed
	if button_pressed:
		resolution.disabled = true
	else:
		resolution.disable = false

func _on_borderless_toggled(button_pressed):
	Global.save_data.borderless = button_pressed
	
func _on_resolution_item_selected(index):
	match index:
		0:
			Global.save_data.resolution = Vector2(1280, 960)
		1:
			Global.save_data.resolution = Vector2(960, 720)
		2:
			Global.save_data.resolution = Vector2(720, 540)
			
func _on_fps_item_selected(index):
	match index:
		0:
			Global.save_data.target_fps = 30
		1: 
			Global.save_data.target_fps = 60
		2:
			Global.save_data.target_fps = 75
		3: 
			Global.save_data.target_fps = 114
		4: 
			Global.save_data.target_fps = 120
		5: 
			Global.save_data.target_fps = 240
		6:
			Global.save_data.target_fps = 0
	
#Audio
func _on_master_value_changed(value):
	Global.save_data.master_db = value

func _on_bgm_value_changed(value):
	Global.save_data.bgm_db = value

func _on_sfx_value_changed(value):
	Global.save_data.sfx_db = value
