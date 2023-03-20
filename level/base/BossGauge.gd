extends TextureProgressBar
class_name BossGauge

##Fill the gauge.
func fill_gauge(val:float) -> Tween:
	max_value = val
	var tween := create_tween()
	tween.tween_property(self, 'value', val, 2.0)

	return tween

##Tween the gauge.
func timer_start():
	create_tween().tween_property(self, 'value', 0.0, value)
