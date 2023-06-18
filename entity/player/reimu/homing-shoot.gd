extends Node2D

@export var timer1 : Timer
@export var timer2 : Timer

@export var shader_mat : ShaderMaterial

func _open_fire() -> void:
	timer1.start()
	timer2.start()
	shader_mat.set_shader_parameter("time_scale", 3)
	modulate = Color.WHITE
		
func _stop_fire() -> void:
	timer1.stop()
	timer2.stop()
	shader_mat.set_shader_parameter("time_scale", 1)
	modulate.a = .5
