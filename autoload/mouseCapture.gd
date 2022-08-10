extends input_handler

func move(delta:float) -> void:
	player.global_position = Global.get_global_mouse_position()
