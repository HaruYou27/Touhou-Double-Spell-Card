extends Slider
class_name PercentageSlider

@export var label :FormatLabel
var sfx := AudioStreamPlayer.new()

func _ready() -> void:
	_value_changed(value)
	sfx.bus = 'SFX'
	sfx.stream = preload("res://autoload/SoundEffect/ui/tick-.wav")
	add_child(sfx)

func _value_changed(_new_value) -> void:
	label.update_label(get_percentage())

func get_percentage() -> int:
	var raw := (value - min_value) / (max_value - min_value)
	sfx.pitch_scale = 1 + raw
	sfx.play()
	
	return raw * 100
