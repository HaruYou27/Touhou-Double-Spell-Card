extends FormatLabel

func _process(_delta):
	update_label(Performance.get_monitor(Performance.TIME_FPS))
