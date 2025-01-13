extends GPUParticles2D
class_name Particles2D

@onready var graphic_level := Global.user_data.graphic_level

func _ready() -> void:
	change_graphic()
	Global.update_graphic.connect(change_graphic)
	
func change_graphic() -> void:
	amount *= Global.user_data.particle_amount
	match graphic_level:
		UserData.GRAPHIC_LEVEL.ULTRA:
			fixed_fps = 60
			interpolate = false
			fract_delta = true
			show()
		UserData.GRAPHIC_LEVEL.HIGH:
			fixed_fps = 30
			interpolate = true
			fract_delta = true
			show()
		UserData.GRAPHIC_LEVEL.MEDIUM:
			fract_delta = false
			fixed_fps = 24
			interpolate = true
			show()
		UserData.GRAPHIC_LEVEL.LOW:
			fract_delta = false
			fixed_fps = 24
			interpolate = false
			show()
		UserData.GRAPHIC_LEVEL.MINIMAL:
			hide()
