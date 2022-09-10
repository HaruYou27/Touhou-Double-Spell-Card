extends Button
class_name AnimatedButton

onready var default_pos := rect_position
var final_pos :Vector2

onready var press_fx :AudioStreamPlayer = $pressFX
onready var focus_fx :AudioStreamPlayer = $focusFX

export (Vector2) var velocity := Vector2(20, 0)
export (float) var animation_length := .15

func _ready() -> void:
	final_pos = default_pos + velocity
	
	connect("focus_entered", self, '_on_focus_entered')
	connect("focus_exited", self, "_on_focus_exited")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, '_on_focus_exited')
	
func _pressed() -> void:
	press_fx.play()

func _on_mouse_entered() -> void:
	grab_focus()
	
func _on_focus_entered() -> void:
	focus_fx.play()
	var tween = create_tween()
	tween.tween_property(self, 'rect_position', final_pos, animation_length)
		
func _on_focus_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, 'rect_position', default_pos, animation_length)
