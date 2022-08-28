extends Timer

signal bomb

func _ready() -> void:
	wait_time = Global.save.death_timer
	set_process_unhandled_input(false)
	
func _unhandled_input(event):
	if event.is_action_pressed("bomb"):
		stop()
		emit_signal("bomb")
		
