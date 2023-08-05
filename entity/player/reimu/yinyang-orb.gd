extends Sprite2D

@onready var fire := $GPUParticles2D
func open_fire() -> void:
	material.set_shader_parameter("time_scale", 3.)
	fire.emitting = true
	
func close_fire() -> void:
	material.set_shader_parameter("time_scale", 1.)
	fire.emitting = false
