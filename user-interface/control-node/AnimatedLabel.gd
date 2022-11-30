extends Label
class_name AnimatedLabel

export (float) var duration := .15

func animate():
	show()
	rect_scale.y = .1
	create_tween().tween_property(self, 'rect_scale', Vector2.ONE, duration)
	
func reset():
	var tween := create_tween()
	tween.tween_property(self, 'rect_scale', Vector2(1.0, .1), duration)
	tween.connect("finished", self, 'hide')
