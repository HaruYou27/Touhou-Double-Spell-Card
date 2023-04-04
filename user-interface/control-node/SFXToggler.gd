extends CheckButton
class_name SFXToggler

@export var invert := false

func _ready() -> void:
	mouse_entered.connect(Callable(SoundEffect,"hover"))

func _toggled(button_pressed:bool) -> void:
	if invert:
		SoundEffect.press(not button_pressed)
	else:
		SoundEffect.press(button_pressed)
