extends Control

func _ready():
	Global.connect("dying", self, "_alert")

func _alert():
	Global.disconnect('player_died', get_parent(), '_on_Restart_pressed')
	Global.connect("player_bombed", self, "_tutorial_done")
	add_child(Dialogic.start('/tutorial/move'))

func _tutorial_done():
	queue_free()
