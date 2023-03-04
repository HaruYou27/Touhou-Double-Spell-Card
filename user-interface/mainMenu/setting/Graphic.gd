extends VBoxContainer

@onready var config :UserData = Global.user_data

@onready var fullscreen :Button = $fullscreen
@onready var borderless :Button = $borderless
@onready var rewind :Button = $rewind
@onready var DynamicBackground :Button = $DynamicBackground
@onready var particle :Button = $particle

func _ready() -> void:
	fullscreen.set_pressed_no_signal(((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))
	borderless.set_pressed_no_signal(get_window().borderless)
	rewind.set_pressed_no_signal(config.rewind)
	DynamicBackground.set_pressed_no_signal(config.dynamic_background)
	particle.set_pressed_no_signal(config.full_particle)
	
func _on_fullscreen_toggled(button_pressed:bool) -> void:
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (button_pressed) else Window.MODE_WINDOWED

func _on_borderless_toggled(button_pressed:bool) -> void:
	get_window().borderless = button_pressed

func _exit_tree() -> void:
	ProjectSettings.set_setting('display/window/size/borderless', get_window().borderless)
	ProjectSettings.set_setting('display/window/size/fullscreen', ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))
	config.dynamic_background = DynamicBackground.button_pressed
	config.full_particle = particle.button_pressed
	config.rewind = rewind.button_pressed

func _on_reset_pressed() -> void:
	fullscreen.button_pressed = false
	borderless.button_pressed = false
	rewind.set_pressed_no_signal(true)
	particle.set_pressed_no_signal(true)
	DynamicBackground.set_pressed_no_signal(true)
