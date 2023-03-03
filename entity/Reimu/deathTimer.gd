extends Timer

signal bomb

#Because everything is paused when player at deathdoor.
func _unhandled_input(event):
	if event.is_action_pressed("bomb"):
		emit_signal("bomb")
