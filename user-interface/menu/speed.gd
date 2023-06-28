extends PercentageSlider

func get_percentage() -> int:
	var raw := 1 / value
	sfx.pitch_scale = 1 + raw
	sfx.play()
	
	return raw * 100
