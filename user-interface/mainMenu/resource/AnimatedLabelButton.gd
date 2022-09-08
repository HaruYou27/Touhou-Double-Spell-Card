extends AnimatedTextButton
class_name AnimatedLabelButton

onready var focus_color := get_color('font_color_focus')
onready var press_color := get_color('font_color_pressed')

export (NodePath) var label

func _ready() -> void:
	label = get_node(label)
	connect("button_down", self, '_on_button_down')
	connect("button_up", self, "_on_focus_exited")
	
func _on_focus_entered() -> void:
	._on_focus_entered()
	label.add_color_override('font_color', focus_color)
	
func _on_button_down() -> void:
	cursor.add_color_override('font_color', press_color)
	
func _on_focus_exited() -> void:
	._on_focus_exited()
	label.remove_color_override('font_color')
