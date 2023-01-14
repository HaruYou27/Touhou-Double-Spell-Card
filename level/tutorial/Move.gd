extends Node2D

func _ready():
	get_tree().call_group('player_bullet', 'stop')
	set_notify_transform(true)

func _notification(what):
	if what == CanvasItem.NOTIFICATION_TRANSFORM_CHANGED:
		Global.emit_signal("next_level")
		$Timer.queue_free()

func _on_Timer_timeout():
	Global.level.add_child(Dialogic.start('/tutorial/move'))
