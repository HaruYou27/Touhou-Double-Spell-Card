extends GPUParticles2D
class_name Particles2D

func _ready() -> void:
	amount *= Global.user_data.particle_amount
