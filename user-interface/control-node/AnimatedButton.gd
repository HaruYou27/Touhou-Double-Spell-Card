extends SFXButton
class_name AnimatedButton

onready var default_pos := rect_position
var final_pos :Vector2

export (Vector2) var offset := Vector2(20, 0)
export (float) var animation_length := .15

var cursor_pos
export (NodePath) var cursor

func _ready():
	cursor = get_node(cursor)
	cursor_pos = Vector2(rect_position.x - 30, rect_position.y + rect_size.y / 2)
	final_pos = default_pos + offset
	
	connect("focus_entered", self, '_on_focus_entered')
	connect("focus_exited", self, "_on_focus_exited")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, '_on_focus_exited')
	
func _on_mouse_entered():
	grab_focus()
	
func _on_focus_entered():
	var tween = create_tween()
	tween.tween_property(cursor, 'position', cursor_pos, animation_length)
	tween.parallel().tween_property(self, 'rect_position', final_pos, animation_length)

func _on_focus_exited():
	var tween = create_tween()
	tween.tween_property(self, 'rect_position', default_pos, animation_length)
