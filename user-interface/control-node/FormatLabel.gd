extends Label
class_name FormatLabel
##Label with built-in string formating.

##Save the original string as template.
@onready var template := text

##Format the text.
func update_label(value):
	text = template % value
