extends AnimatedButton
class_name AnimatedTextButton

var cursor_pos
export (NodePath) var cursor

func _ready():
	cursor = get_node(cursor)
	cursor_pos = Vector2(cursor.position.x, rect_position.y + rect_size.y / 2)
	
func _on_focus_entered():
	._on_focus_entered()
	create_tween().tween_property(cursor, 'position', cursor_pos, animation_length)
