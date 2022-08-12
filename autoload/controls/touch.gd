extends input_handler

static func move(_delta:float, position:Vector2) -> Vector2:
	if Input.is_action_just_pressed("shoot"):
		Global.global_position = Global.get_global_mouse_position()
	var mouse_pos := Global.get_local_mouse_position()
	var delta_pos := mouse_pos - position
	
	if delta_pos.length() <= Global.speed / 2:
		Input.action_press("focus")
	else:
		Input.action_release("focus")
	
	return mouse_pos + position
