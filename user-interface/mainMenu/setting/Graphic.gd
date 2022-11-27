extends HBoxContainer

onready var save := Global.config

onready var fullscreen :AnimatedTextButton = $settings/fullscreen
onready var borderless :AnimatedTextButton = $settings/borderless

func _ready():
	fullscreen.set_pressed_no_signal(OS.window_fullscreen)
	borderless.set_pressed_no_signal(OS.window_borderless)
	
func _on_fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	ProjectSettings.set_setting('display/window/size/fullscreen', button_pressed)

func _on_borderless_toggled(button_pressed):
	OS.window_borderless = button_pressed
	ProjectSettings.set_setting('display/window/size/borderless', button_pressed)

func _on_graphic_reset_pressed():
	fullscreen.pressed = false
	borderless.pressed = false

func _on_rewind_toggled(button_pressed):
	save.rewind = button_pressed
