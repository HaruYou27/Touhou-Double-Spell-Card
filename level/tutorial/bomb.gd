extends Label

func _ready() -> void:
	var timer := Global.player.death_timer
	timer.timeout.disconnect(Callable(Global.leveler,'restart'))
	timer.timeout.connect(Callable(self,'_alert').bind(),4)

func _alert() -> void:
	Global.bomb_impact.connect(Callable(self,"_tutorial_done"))
	show()

func _tutorial_done() -> void:
	Global.player.death_timer.timeout.connect(Callable(Global.leveler,'restart'))
	queue_free()
