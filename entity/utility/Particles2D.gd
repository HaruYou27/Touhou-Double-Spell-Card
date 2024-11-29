extends GraphicOptional
class_name Particles2D

## Work around GDscript limited inhernitance.
func change_graphic() -> void:
	var particles2d: GPUParticles2D = $"."
	particles2d.amount *= Global.user_data.particle_amount
