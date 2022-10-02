extends FormatLabel

func _ready():
	if Global.save_data.show_fps:
		return
	queue_free()

func _process(_delta):
	update_label(Performance.get_monitor(Performance.TIME_FPS))
