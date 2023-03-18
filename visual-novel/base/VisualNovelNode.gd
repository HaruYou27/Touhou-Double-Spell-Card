extends TextureRect
class_name VisualNovelNode

@onready var container := $ScrollContainer/GridContainer
@export var add_row := false : set _add_row

@export var textbox : PackedScene

func _ready() -> void:
	for child in container.get_children():
		child.hide()

func push_message(portrait:Texture2D, message:String, mirror := false) -> void:
	var avatar := TextureButton.new()
	avatar.texture_normal = portrait
	
	var label : = textbox.instantiate()
	label.parse_text(message)
	container.add_child(label)

	if mirror:
		container.add_child(Control.new())
		container.add_child(label)
		avatar.flip_h = true
		container.add_child(avatar)
	else:
		container.add_child(avatar)
		container.add_child(label)
		container.add_child(Control.new())
