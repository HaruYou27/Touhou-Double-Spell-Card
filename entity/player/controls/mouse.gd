extends KeyboardInput
class_name MouseInput

func _physics_process(_delta):
	var mouse_local := player.get_local_mouse_position()
	if not mouse_local:
		return
	
	player.global_position = player.get_global_mouse_position()
	player.position.x = clamp(player.position.x, 0.0, 646.0)
	player.position.y = clamp(player.position.y, 0.0, 904.0)
