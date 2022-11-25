extends FormatLabel

func _process(_delta):
	update_label(Performance.get_monitor(int(Performance.TIME_FPS)))
