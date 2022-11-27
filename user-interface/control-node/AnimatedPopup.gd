extends Popup
class_name AnimatedPopup

export (float) var animation_length := .15
export (Vector2) var min_size := Vector2(.05, .05)

onready var default_pos := rect_position

onready var canvas_layer :CanvasLayer = get_parent()

func _ready():
	rect_pivot_offset = rect_size / 2
	rect_scale = min_size
	
	connect("popup_hide", self, '_hide')
	
func _hide():
	show()
	var tween := create_tween()
	tween.tween_property(self, 'rect_scale', min_size, .15)
	tween.connect("finished", self, "hide")
	tween.connect("finished", canvas_layer, "hide")
	
func popup(bound = Rect2()):
	.popup(bound)
	canvas_layer.show()
	rect_position = default_pos
	create_tween().tween_property(self, 'rect_scale', Vector2.ONE, animation_length)
