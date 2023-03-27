extends GPUParticles2D
class_name Particle

func _ready():
	if Global.user_data.full_particle:
		return
		
	amount /= 2
	fixed_fps /= 2
