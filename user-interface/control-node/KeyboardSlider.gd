extends HSlider
class_name KeyboardHSlider

var cursor_pos
export (NodePath) var cursor

export (NodePath) var label
var template :String

export (float) var duration := .15
export (int) var cursor_offset_x := 40
export (bool) var raw_value := false

var percentage := 0.0
onready var focus_color := get_color('font_color_focus', 'Button')

func _ready():
	label = get_node(label)
	template = label.text
	
	if not raw_value:
		percentage = 100 / max_value
		get_percentage()
	else:
		label.text = template % value
	
	cursor = get_node(cursor)
	cursor_pos = Vector2(rect_position.x - cursor_offset_x, rect_position.y + rect_size.y / 2)
	
	connect("focus_entered", self, '_on_focus_entered')
	connect("focus_exited", label, "remove_color_override", ['font_color'])
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", label, 'remove_color_override', ['font_color'])
	connect("value_changed", self, '_on_value_changed')
	
func _on_mouse_entered():
	grab_focus()
	
func get_percentage():
	#In case min_value < 0
	label.text = template % (value * percentage)
	
func _on_focus_entered():
	label.add_color_override('font_color', focus_color)
	create_tween().tween_property(cursor, 'position', cursor_pos, duration)

func _on_value_changed(value):
	if raw_value:
		label.text = template % value
		return
	get_percentage()
