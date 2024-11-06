extends FormatLabel

func _on_timer_timeout():
	update_label(Performance.get_monitor(Performance.TIME_FPS))
