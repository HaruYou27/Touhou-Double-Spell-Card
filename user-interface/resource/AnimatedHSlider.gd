extends HSlider
class_name AnimatedHSlider

var cursor_pos
export (NodePath) var cursor

export (NodePath) var label
var template :String
var default_pos :Vector2
var final_pos :Vector2

onready var focus_fx :AudioStreamPlayer = $focusFX
onready var focus_color := get_color('font_color_focus', 'Button')

export (Vector2) var velocity := Vector2(20, 0)
export (float) var animation_length := .15

onready var percentage = 100 / (max_value + abs(min_value))

func _ready() -> void:
	label = get_node(label)
	template = label.text
	label.text = label.text % get_percentage()
	default_pos = label.rect_position
	
	final_pos = default_pos + velocity
	cursor = get_node(cursor)
	cursor_pos = Vector2(cursor.position.x, rect_position.y + rect_size.y / 2)
	
	connect("focus_entered", self, '_on_focus_entered')
	connect("focus_exited", self, "_on_focus_exited")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, '_on_focus_exited')
	connect("value_changed", self, '_on_value_changed')
	
func _on_mouse_entered() -> void:
	grab_focus()
	
func get_percentage() -> int:
	return int((value + abs(min_value)) * percentage)
	
func _on_focus_entered() -> void:
	focus_fx.play()
	label.add_color_override('font_color', focus_color)
	var tween = create_tween()
	tween.tween_property(cursor, 'position', cursor_pos, animation_length)
	tween.parallel().tween_property(label, 'rect_position', final_pos, animation_length)
		
func _on_focus_exited() -> void:
	label.remove_color_override('font_color')
	var tween = create_tween()
	tween.tween_property(label, 'rect_position', default_pos, animation_length)

func _on_value_changed(value) -> void:
	label.text = template % get_percentage()
