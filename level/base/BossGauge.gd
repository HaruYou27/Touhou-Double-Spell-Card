extends TextureProgressBar

func hide_gauge():
	create_tween().tween_property(self, 'modulate', Color.TRANSPARENT, .5)

func show_gauge():
	create_tween().tween_property(self, 'modulate', Color.WHITE, .5)

func fill_gauge(val:float) -> Tween:
	max_value = val
	var tween := create_tween()
	tween.tween_property(self, 'value', val, 2.0)

	return tween

func _timer_start():
	create_tween().tween_property(self, 'value', 0.0, value)
