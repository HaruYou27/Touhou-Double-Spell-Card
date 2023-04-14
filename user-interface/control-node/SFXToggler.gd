extends CheckButton
class_name SFXToggler

@export var invert := false

func _ready() -> void:
	mouse_entered.connect(SoundEffect.hover)

func _toggled(_button_pressed) -> void:
	if invert:
		SoundEffect.press(not button_pressed)
	else:
		SoundEffect.press(button_pressed)
