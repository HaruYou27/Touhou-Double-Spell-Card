extends Node

func start():
	Global.player.death_tween.disconnect
	Global.player.death_tween.connect("tween_all_completed", Global, 'emit_signal')

func _alert():
	Global.disconnect('player_died', get_parent(), '_on_Restart_pressed')
	Global.connect("player_bombed", self, "_tutorial_done")
	add_child(Dialogic.start('/tutorial/move'))

func _tutorial_done():
	queue_free()
