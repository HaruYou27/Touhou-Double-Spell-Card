extends VBoxContainer

@onready var user_data :UserData = Global.user_data
@onready var window := get_window()
@onready var vulkan := $vulkan
@onready var particles := $Particles

func _ready() -> void:
	fullscreen.set_pressed_no_signal(window.mode)
	borderless.set_pressed_no_signal(window.borderless)
	particles.value = user_data.particle_amount
	if ProjectSettings.get_setting('rendering/renderer/rendering_method') == 'mobile':
		vulkan.set_pressed_no_signal(true)
	
@onready var fullscreen :Button = $fullscreen
func _on_fullscreen_toggled(button_pressed:bool) -> void:
	if button_pressed:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED

@onready var borderless :Button = $borderless
func _on_borderless_toggled(button_pressed:bool) -> void:
	window.borderless = button_pressed

func _exit_tree() -> void:
	ProjectSettings.set_setting('display/window/size/borderless', window.borderless)
	if vulkan:
		ProjectSettings.set_setting('rendering/renderer/rendering_method', 'mobile')
		ProjectSettings.set_setting('rendering/renderer/rendering_method.mobile', 'mobile')
	else:
		ProjectSettings.set_setting('rendering/renderer/rendering_method', 'gl_compatibility')
		ProjectSettings.set_setting('rendering/renderer/rendering_method.mobile', 'gl_compatibility')
		
	user_data.particle_amount = particles.value

func _on_reset_pressed() -> void:
	fullscreen.button_pressed = false
	borderless.button_pressed = false
