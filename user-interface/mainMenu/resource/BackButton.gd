extends Button
class_name BackButton

onready var focus_fx :AudioStreamPlayer = $focusFX
onready var press_fx :AudioStreamPlayer = $pressFX

onready var focus_color := get_color('font_color_focus')
onready var press_color := get_color('font_color_pressed')

export (Vector2) var direction := Vector2.LEFT
export (float) var animation_length := .15
export (int) var offset := 10
export (NodePath) var cursor

var cursor_pos : Vector2
var cursor_default_pos :Vector2

func _ready() -> void:
	cursor = get_node(cursor)
	direction = direction.normalized() * offset
	cursor_pos = cursor.rect_position + direction
	cursor_default_pos = cursor.rect_position
	
	shortcut = preload("res://user-interface/mainMenu/resource/back.res")
	flat = true

	connect("focus_entered", self, '_on_focus_entered')
	connect("focus_exited", self, "_on_focus_exited")
	connect("mouse_entered", self, "_on_focus_entered")
	connect("mouse_exited", self, '_on_focus_exited')
	connect("button_down", self, '_on_button_down')
	connect("button_up", self, '_on_focus_exited')

func _pressed() -> void:
	disabled = true
	press_fx.play()
	
func _on_button_down() -> void:
	cursor.add_color_override('font_color', press_color)
	create_tween().tween_property(cursor, 'rect_position', cursor_pos, animation_length)
	
func _on_focus_entered() -> void:
	focus_fx.play()
	cursor.add_color_override('font_color', focus_color)
	create_tween().tween_property(cursor, 'rect_position', cursor_pos, animation_length)
	
func _on_focus_exited() -> void:
	cursor.remove_color_override('font_color')
	create_tween().tween_property(cursor, 'rect_position', cursor_default_pos, animation_length)
