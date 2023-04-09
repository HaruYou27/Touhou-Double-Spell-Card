extends Button
class_name SFXButton

@export var press_sfx := true

@onready var template := text
func update_label(value) -> void:
	text = template % value

func _ready() -> void:
	mouse_entered.connect(SoundEffect.hover)
	pressed.connect(SoundEffect.press.bind(press_sfx))
