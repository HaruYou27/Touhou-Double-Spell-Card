extends PercentageSlider

func get_percentage() -> int:
	sfx.pitch_scale = 1 + value
	sfx.play()
	
	return int(value * 100)
