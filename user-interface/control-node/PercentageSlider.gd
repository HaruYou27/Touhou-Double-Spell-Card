extends Slider
class_name PercentageSlider

@export var label :FormatLabel

func _ready() -> void:
	drag_ended.connect(Callable(self, '_draged'))

func _draged(new:bool) -> void:
	if new:
		label.update_label(get_percentage())

func get_percentage() -> int:
	return (value + min_value) / (max_value + min_value) * 100
