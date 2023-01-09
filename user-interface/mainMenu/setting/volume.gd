extends KeyboardHSlider

func _ready():
	raw_value = false
	percentage = 100 / (abs(min_value) + max_value)
	get_percentage()
	
func get_percentage():
	label.text = template % int((value + abs(min_value)) * percentage)
