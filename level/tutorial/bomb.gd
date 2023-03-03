extends Node

func _ready():
	var timer := Global.player.death_timer
	timer.disconnect("timeout",Callable(Global.leveler,'restart'))
	timer.connect("timeout",Callable(self,'_alert').bind(),4)

func _alert():
	Global.connect("bomb_impact",Callable(self,"_tutorial_done"))
	add_child(Dialogic.start('/tutorial/move'))

func _tutorial_done():
	Global.player.death_timer.connect("timeout",Callable(Global.leveler,'restart'))
	queue_free()
