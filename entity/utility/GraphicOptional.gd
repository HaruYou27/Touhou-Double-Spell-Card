extends Node2D
class_name GraphicOptional

@export() var graphic_level :UserData.GRAPHIC_LEVEL = 3

func _ready() -> void:
	if Global.user_data.graphic_level < graphic_level:
		hide()
