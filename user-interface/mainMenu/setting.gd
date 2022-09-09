extends Control

#Graphic
onready var fps :ScrollButton = $TabContainer/Graphic/GridContainer/fps
onready var resolution :ScrollButton = $TabContainer/Graphic/GridContainer/resolution
onready var fullscreen :AnimatedTextButton = $TabContainer/Graphic/fullscreen
onready var borderless :AnimatedTextButton = $TabContainer/Graphic/borderless
onready var shake :AnimatedTextButton = $TabContainer/Graphic/shake
onready var flash :AnimatedTextButton = $TabContainer/Graphic/flash
onready var vsync :AnimatedTextButton = $TabContainer/Graphic/vsync

onready var back :BackButton = $back
onready var tabcontainer :TabContainer = $TabContainer

func _ready() -> void:
	vsync.set_pressed_no_signal(Global.save_data.vsync)
	fullscreen.set_pressed_no_signal(Global.save_data.fullscreen)
	flash.set_pressed_no_signal(Global.save_data.screen_flash)
	shake.set_pressed_no_signal(Global.save_data.screen_shake)
	vsync.set_pressed_no_signal(Global.save_data.vsync)
	resolution.item = resolution.items.find(Global.save_data.resolution)
	fps.item = fps.items.find(Global.save_data.target_fps)

func _on_settings_pressed():
	back.disabled = false
	
func _on_reset_pressed():
	var tab = tabcontainer.current_tab
	match tab:
		0:
			AudioServer.set_bus_volume_db(2, -80)
			vsync.pressed = false
			fps.selected = 1
			resolution.selected = 1
			fullscreen.pressed = false
			borderless.pressed = false
			flash.pressed = true
			shake.pressed = true
			AudioServer.set_bus_volume_db(2, 0)

#Graphic
func _on_vsync_toggled(button_pressed):
	Global.save_data.vsync = button_pressed
	fps.disabled = button_pressed

func _on_flash_toggled(button_pressed):
	Global.save_data.screen_flash = button_pressed

func _on_shake_toggled(button_pressed):
	Global.save_data.screen_shake = button_pressed

func _on_autoshoot_toggled(button_pressed):
	Global.save_data.auto_shoot = button_pressed

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
func _on_master_value_changed(value):
	Global.save_data.master_db = value

func _on_bgm_value_changed(value):
	Global.save_data.bgm_db = value

func _on_sfx_value_changed(value):
	Global.save_data.sfx_db = value
