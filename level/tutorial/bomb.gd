extends Label

signal next_event

func start_event() -> void:
	var timer := Global.player.death_timer
	timer.timeout.disconnect(Callable(timer, '_on_timeout'))
	timer.timeout.connect(Callable(self,'_alert'),4)
	Global.player.bomb_count = 1

func _alert() -> void:
	Global.bomb_impact.connect(Callable(self,"_tutorial_done"))
	show()

func _tutorial_done() -> void:
	next_event.emit()
	queue_free()
