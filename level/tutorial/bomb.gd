extends Node

func _ready() -> void:
	var timer := Global.player.death_timer
	timer.timeout.disconnect(Callable(Global.leveler,'restart'))
	timer.timeout.connect(Callable(self,'_alert').bind(),4)

func _alert() -> void:
	Global.connect("bomb_impact",Callable(self,"_tutorial_done"))
	add_child(Dialogic.start('/tutorial/move'))

func _tutorial_done() -> void:
	Global.player.death_timer.timeout.connect(Callable(Global.leveler,'restart'))
	queue_free()
