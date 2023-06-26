extends VBoxContainer

@onready var config :UserData = Global.user_data
@onready var window := get_window()

@onready var fullscreen :Button = $fullscreen
@onready var borderless :Button = $borderless

func _ready() -> void:
	fullscreen.set_pressed_no_signal(window.mode)
	borderless.set_pressed_no_signal(window.borderless)
	
func _on_fullscreen_toggled(button_pressed:bool) -> void:
	if button_pressed:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED

func _on_borderless_toggled(button_pressed:bool) -> void:
	window.borderless = button_pressed

func _exit_tree() -> void:
	ProjectSettings.set_setting('display/window/size/borderless', window.borderless)

func _on_reset_pressed() -> void:
	fullscreen.button_pressed = false
	borderless.button_pressed = false
