extends Button
class_name UberButton

export (AudioStream) var focus_sfx
export (AudioStream) var press_sfx

export (float) var duration := .15
export (Vector2) var self_offset : Vector2
onready var default_pos := rect_position

export (Vector2) var cursor_offset := Vector2(40, 0)
export (NodePath) var cursor

onready var template := text
func update_label(value):
	text = template % value

func _ready():
	connect("mouse_entered", self, 'grab_focus')
	
	if cursor:
		cursor = get_node(cursor)
		cursor_offset = rect_position - cursor_offset
		cursor_offset.y += rect_size.y / 2
		connect("focus_entered", self, '_move_cursor')

	if self_offset:
		self_offset = rect_position + self_offset
		connect("focus_entered", self, '_focus')
		connect("focus_exited", self, "_unfocus")

	if press_sfx:
		var Focus_sfx := AudioStreamPlayer.new()
		Focus_sfx.stream = focus_sfx
		connect("focus_entered", Focus_sfx, "play")
		add_child(Focus_sfx)

		var Press_sfx := AudioStreamPlayer.new()
		Press_sfx.stream = press_sfx
		connect("focus_entered", Press_sfx, "play")
		add_child(Press_sfx)

func _move_cursor():
	create_tween().tween_property(cursor, 'position', cursor_offset, duration)

func _focus():
	create_tween().tween_property(self, 'rect_position', self_offset, duration)

func _unfocus():
	create_tween().tween_property(self, 'rect_position', default_pos, duration)
