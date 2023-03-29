@tool
extends GridContainer

@export var add_message := false : set = _add_message
func _add_message(_value:bool) -> void:
	add_child(TextureRect.new())
	add_child(RichTextLabel.new())
