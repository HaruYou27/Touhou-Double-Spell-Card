extends Slider
class_name PercentageSlider

@export var label :FormatLabel

func _value_changed(_new_value) -> void:
	label.update_label(get_percentage())

func get_percentage() -> int:
	return (value - min_value) / (max_value - min_value) * 100
