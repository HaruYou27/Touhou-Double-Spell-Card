extends ColorRect

onready var tree := get_tree()

func _input(event):
	if event.is_action_pressed('focus'):
		Global.emit_signal("next_level")
		set_process_input(false)

func _on_Timer_timeout():
	pass
