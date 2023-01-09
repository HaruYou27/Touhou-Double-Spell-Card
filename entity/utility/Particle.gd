extends Particles2D
class_name Particle

func _ready():
	if Global.user_setting.full_particle:
		return
		
	amount /= 2
