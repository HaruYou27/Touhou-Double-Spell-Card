tool
extends FocusedBoxcontainer

onready var config := Global.config

onready var fullscreen :Button = $fullscreen
onready var borderless :Button = $borderless
onready var rewind :Button = $rewind
onready var DynamicBackground :Button = $DynamicBackground
onready var particle :Button = $particle

func _ready():
	fullscreen.set_pressed_no_signal(OS.window_fullscreen)
	borderless.set_pressed_no_signal(OS.window_borderless)
	rewind.set_pressed_no_signal(config.rewind)
	DynamicBackground.set_pressed_no_signal(config.dynamic_background)
	particle.set_pressed_no_signal(config.full_particle)
	
func _on_fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_borderless_toggled(button_pressed):
	OS.window_borderless = button_pressed

func _on_graphic_reset_pressed():
	fullscreen.pressed = false
	borderless.pressed = false
	rewind.pressed = true
	particle.pressed = true
	DynamicBackground.pressed = true

func _exit_tree():
	ProjectSettings.set_setting('display/window/size/borderless', OS.window_borderless)
	ProjectSettings.set_setting('display/window/size/fullscreen', OS.window_fullscreen)
	config.dynamic_background = DynamicBackground.pressed
	config.full_particle = particle.pressed
	config.rewind = rewind.pressed
