extends Timer

signal bomb

func _init() -> void:
	wait_time = Global.save.death_timer
	
func _unhandled_input(event):
	if event.is_action_pressed("bomb"):
		stop()
		emit_signal("bomb")
		
