extends Node2D
class_name GraphicOptional

@export var graphic_level :UserData.GRAPHIC_LEVEL = UserData.GRAPHIC_LEVEL.HIGH

func _ready() -> void:
	change_graphic()
	Global.update_graphic.connect(change_graphic)
	
func change_graphic() -> void:
	if Global.user_data.graphic_level < graphic_level:
		hide()
		process_mode = PROCESS_MODE_DISABLED
	else:
		show()
		process_mode = PROCESS_MODE_INHERIT
	
