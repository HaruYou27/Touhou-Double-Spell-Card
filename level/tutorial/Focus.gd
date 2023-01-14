extends ColorRect

onready var tree := get_tree()

func _input(event):
	if event.is_action_pressed('focus'):
		Global.emit_signal("next_level")
		set_process_input(false)

func start():
	if Global.user_setting.use_mouse:
		Global.emit_signal("next_level")
	else:
		Global.level.add_child(Dialogic.start('/tutorial/focus'))
