extends GraphicOptional
class_name GraphicFallback
## Low quality graphic for low-end devices.

func change_graphic() -> void:
	if Global.user_data.graphic_level == graphic_level:
		show()
		process_mode = PROCESS_MODE_INHERIT
	else:
		hide()
		process_mode = PROCESS_MODE_DISABLED
