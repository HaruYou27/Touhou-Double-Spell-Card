extends CanvasItem
class_name GraphicOptional

@export var graphic_level :UserData.GRAPHIC_LEVEL = UserData.GRAPHIC_LEVEL.HIGH

func _ready() -> void:
	if Global.user_data.graphic_level < graphic_level:
		hide()
