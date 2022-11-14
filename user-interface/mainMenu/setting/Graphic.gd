extends HBoxContainer

onready var save := Global.save_data

onready var fullscreen :AnimatedTextButton = $settings/fullscreen
onready var borderless :AnimatedTextButton = $settings/borderless

func _ready() -> void:
	fullscreen.pressed = save.fullscreen
	borderless.pressed = save.borderless
	
func _on_reset_pressed():
	AudioServer.set_bus_volume_db(2, -80)
	
	fullscreen.pressed = false
	borderless.pressed = false
	
	AudioServer.set_bus_volume_db(2, 0)

func _on_fullscreen_toggled(button_pressed):
	save.fullscreen = button_pressed

func _on_borderless_toggled(button_pressed):
	save.borderless = button_pressed
