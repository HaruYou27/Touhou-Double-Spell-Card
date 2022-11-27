extends Particles2D
class_name Particle

func _ready():
	if Global.config.full_particle:
		return
		
	amount /= 2
