extends AnimatedButton
class_name BackButton

onready var focus_color := get_color('font_color_focus')
onready var press_color := get_color('font_color_pressed')

export (NodePath) var cursor

var cursor_pos : Vector2
var cursor_default_pos :Vector2

func _ready() -> void:
	disabled = true
	cursor = get_node(cursor)
	cursor_pos = cursor.rect_position + velocity
	cursor_default_pos = cursor.rect_position
	
	shortcut = preload("res://user-interface/resource/escape.res")
	flat = true

	connect("button_down", self, '_on_button_down')
	connect("button_up", self, '_on_focus_exited')

func _pressed() -> void:
	disabled = true
	
func _on_mouse_entered() -> void:
	_on_focus_entered()
	
func _on_button_down() -> void:
	cursor.add_color_override('font_color', press_color)
	create_tween().tween_property(cursor, 'rect_position', cursor_pos, animation_length)
	
func _on_focus_entered() -> void:
	cursor.add_color_override('font_color', focus_color)
	create_tween().tween_property(cursor, 'rect_position', cursor_pos, animation_length)
	
func _on_focus_exited() -> void:
	cursor.remove_color_override('font_color')
	create_tween().tween_property(cursor, 'rect_position', cursor_default_pos, animation_length)
