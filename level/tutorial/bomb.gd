extends Node

func _ready():
	var timer := Global.player.death_timer
	timer.disconnect("timeout", Global.leveler, 'restart')
	timer.connect("timeout", self, '_alert', [], 4)

func _alert():
	Global.connect("bomb_impact", self, "_tutorial_done")
	add_child(Dialogic.start('/tutorial/move'))

func _tutorial_done():
	Global.player.death_timer.connect("timeout", Global.leveler, 'restart')
	queue_free()
