extends PercentageSlider
class_name PercentageSliderNormalized

func _value_changed(_new_value) -> void:
	sfx.pitch_scale = value
	sfx.play()
	
	label.update_label(int(value * 100))
