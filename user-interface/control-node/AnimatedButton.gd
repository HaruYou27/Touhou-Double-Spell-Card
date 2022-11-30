extends SFXButton
class_name AnimatedButton

export (float) var duration := .15
export (int) var cursor_offset_x := -40

export (NodePath) var path
onready var cursor :Sprite = get_node(path)
onready var cursor_pos := Vector2(rect_position.x - cursor_offset_x, rect_position.y + rect_size.y / 2)

func _ready():
	connect("focus_entered", self, '_on_focus_entered')
	connect("mouse_entered", self, "_on_mouse_entered")
	
func _on_mouse_entered():
	grab_focus()
	
func _on_focus_entered():
	create_tween().tween_property(cursor, 'position', cursor_pos, duration)

