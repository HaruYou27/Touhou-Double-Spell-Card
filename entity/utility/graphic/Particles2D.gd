extends GPUParticles2D
class_name Particles2D

func _ready() -> void:
	change_graphic()
	Global.update_graphic.connect(change_graphic)
	
func change_graphic() -> void:
	var graphic_level := Global.user_data.graphic_level
	amount *= Global.user_data.particle_amount
	fract_delta = graphic_level > UserData.GRAPHIC_LEVEL.LOW
	match graphic_level:
		UserData.GRAPHIC_LEVEL.HIGH:
			fixed_fps = 60
			show()
		UserData.GRAPHIC_LEVEL.MEDIUM:
			fixed_fps = 30
			show()
		UserData.GRAPHIC_LEVEL.LOW:
			fixed_fps = 24
			show()
		UserData.GRAPHIC_LEVEL.MINIMAL:
			hide()
