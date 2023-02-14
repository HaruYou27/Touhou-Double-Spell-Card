extends Particles2D
class_name Particle

func _ready():
	if Global.user_data.full_particle:
		return
		
	amount /= 2
