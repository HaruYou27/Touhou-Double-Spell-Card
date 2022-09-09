extends Label
class_name ScrollButton

signal item_changed(item)

onready var color_focus := get_color("font_color_focus", 'Button')
onready var template := text

export (NodePath) var left
export (NodePath) var right

export (Array) var items :Array
onready var item_count = items.size()
var item = 0 setget _set_item

export (float) var animation_length = .15
export (NodePath) var cursor
var cursor_pos :Vector2

func _ready() -> void:
	set_process_input(false)
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	left = get_node(left)
	right = get_node(right)
	
	cursor = get_node(cursor)
	cursor_pos = Vector2(cursor.position.x, rect_position.y + get_parent().rect_position.y + rect_size.y / 2)
	
	connect("focus_entered", self , '_on_focus_entered')
	connect("focus_exited", self, '_on_focus_exited')
	connect("mouse_entered", self, "_on_focus_entered")
	connect("mouse_exited", self, '_on_focus_exited')
	
func _set_item(value:int) -> void:
	if value < 0:
		item = item_count - 1
	elif value == item_count:
		item = 0
	else:
		item = value
	var item_value = get_item()
	text = template % item_value
	emit_signal("item_changed", item_value)
		
func get_item():
	return items[item]
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		left.emit_signal('pressed')
		accept_event()
	elif event.is_action_pressed("ui_right"):
		right.emit_signal('pressed')
		accept_event()
	
func _on_focus_entered() -> void:
	add_color_override("font_color", color_focus)
	left.disabled = false
	right.disabled = false
	create_tween().tween_property(cursor, 'position', cursor_pos, animation_length)
	set_process_input(true)

func _on_focus_exited() -> void:
	set_process_input(false)
	left.disabled = true
	right.disabled = true
	remove_color_override('font_color')

func _on_left_pressed():
	self.item -= 1

func _on_right_pressed():
	self.item += 1
