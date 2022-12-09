extends KeyboardButton

onready var template := text

func update_label(value):
	text = template % value
