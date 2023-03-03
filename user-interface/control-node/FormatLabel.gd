extends Label
class_name FormatLabel

@onready var template := text

func update_label(value):
	text = template % value
