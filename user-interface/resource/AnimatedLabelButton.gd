extends AnimatedButton
class_name AnimatedLabelButton

export (NodePath) var label
var label_default_pos :Vector2
var label_pos :Vector2

onready var focus_color := get_color('font_color_focus')
onready var press_color := get_color('font_color_pressed')

func _ready() -> void:
	label = get_node(label)
	label_default_pos = label.rect_position
	label_pos = label_default_pos + velocity
	connect("button_down", self, '_on_button_down')
	
func _on_focus_entered() -> void:
	._on_focus_entered()
	label.add_color_override('font_color', focus_color)
	create_tween().tween_property(label, 'rect_position', label_pos, animation_length)
	
func _on_focus_exited() -> void:
	._on_focus_exited()
	label.remove_color_override('font_color')
	create_tween().tween_property(label, 'rect_position', label_default_pos, animation_length)
	
func _on_button_down() -> void:
	label.add_color_override('font_color', press_color)
