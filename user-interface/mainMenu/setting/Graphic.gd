extends HBoxContainer

onready var config := Global.config

onready var fullscreen :AnimatedButton = $fullscreen
onready var borderless :AnimatedButton = $borderless

func _ready():
	fullscreen.set_pressed_no_signal(OS.window_fullscreen)
	borderless.set_pressed_no_signal(OS.window_borderless)
	
func _on_fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_borderless_toggled(button_pressed):
	OS.window_borderless = button_pressed

func _on_graphic_reset_pressed():
	fullscreen.pressed = false
	borderless.pressed = false

func _on_rewind_toggled(button_pressed):
	config.rewind = button_pressed
	
