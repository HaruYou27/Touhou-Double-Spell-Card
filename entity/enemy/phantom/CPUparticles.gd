extends CPUParticles2D
class_name CPUparticles
	
func  _visibility_changed() -> void:
	emitting = is_visible_in_tree()

func _ready() -> void:
	change_graphic()
	Global.update_graphic.connect(change_graphic)
	visibility_changed.connect(_visibility_changed)
	
func change_graphic() -> void:
	fract_delta = Global.user_data.graphic_level > UserData.GRAPHIC_LEVEL.LOW
	if Global.user_data.graphic_level < UserData.GRAPHIC_LEVEL.LOW:
		fixed_fps = 30
	else:
		fixed_fps = 0
