extends TextureProgress

func hide_gauge():
	create_tween().tween_property(self, 'modulate', Color.transparent, .5)

func show_gauge():
	create_tween().tween_property(self, 'modulate', Color.white, .5)

func fill_gauge(val:float) -> SceneTreeTween:
	max_value = val
	var tween := create_tween()
	tween.tween_property(self, 'value', val, 2.0)

	return tween

func _timer_start():
	create_tween().tween_property(self, 'value', 0.0, value)