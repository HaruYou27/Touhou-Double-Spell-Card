extends AnimatedTextButton

onready var template := text

func update_label(value) -> void:
	text = template % value
