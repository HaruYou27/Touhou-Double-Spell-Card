extends PercentageSlider

func get_percentage() -> int:
	sfx.pitch_scale = 1 + value
	sfx.play()
	
	return value * 100
