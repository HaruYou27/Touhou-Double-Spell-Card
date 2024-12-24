extends CPUparticles
class_name CPUparticlesOptional

func change_graphic() -> void:
	fract_delta = Global.user_data.graphic_level > UserData.GRAPHIC_LEVEL.MEDIUM
	if Global.user_data.graphic_level < UserData.GRAPHIC_LEVEL.MEDIUM:
		fixed_fps = 30
	else:
		fixed_fps = 0
	if Global.user_data.graphic_level < UserData.GRAPHIC_LEVEL.LOW:
		hide()
		process_mode = Node.PROCESS_MODE_DISABLED
		emitting = false
	else:
		show()
		process_mode = Node.PROCESS_MODE_INHERIT
		emitting = true
