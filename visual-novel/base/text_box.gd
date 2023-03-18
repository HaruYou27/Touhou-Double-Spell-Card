extends RichTextLabel
class_name TextBox

@onready var label : RichTextLabel = $TextBox

@export var wiki : Array[Glossary]

func parse_text(message:String) -> void:
	
