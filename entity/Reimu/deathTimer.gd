extends Timer
#Because everything is paused when player at deathdoor.

signal bomb

func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("bomb"):
		emit_signal("bomb")
