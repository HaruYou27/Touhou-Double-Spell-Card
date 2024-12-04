extends Slider
class_name PercentageSlider

@export var label :FormatLabel
var sfx := AudioStreamPlayer.new()

func _ready() -> void:
	_value_changed(value)
	sfx.bus = 'SFX'
	sfx.stream = preload("res://singleton/sound-effect/resource/tick-.wav")
	add_child(sfx)

func _value_changed(_new_value) -> void:
	var raw := (value - min_value) / (max_value - min_value)
	sfx.pitch_scale = 1 + raw
	sfx.play()
	
	label.update_label(int(raw * 100))
