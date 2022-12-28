extends SFXButton
class_name KeyboardButton

export (float) var duration := .15
export (int) var cursor_offset_x := 40

export (NodePath) var cursor
onready var cursor_pos := Vector2(rect_position.x - cursor_offset_x, rect_position.y + rect_size.y / 2)

func _ready():
	cursor = get_node(cursor)
	connect("focus_entered", self, '_on_focus_entered')
	connect("mouse_entered", self, "grab_focus")
	
func _on_focus_entered():
	create_tween().tween_property(cursor, 'position', cursor_pos, duration)
