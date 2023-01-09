extends Node2D

func _ready():
	get_tree().call_group('player_bullet', 'stop')

func _process(delta):
	if global_position:
		Global.emit_signal("next_level")
		$Timer.queue_free()

func _on_Timer_timeout():
	add_child(Dialogic.start('/tutorial/move'))
