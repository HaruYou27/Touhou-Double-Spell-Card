extends Node2D

@onready var timer : Timer = $Timer

@export var shader_mat : ShaderMaterial

func _open_fire() -> void:
	timer.start()
	shader_mat.set_shader_parameter("time_scale", 3.)
	modulate = Color.WHITE
		
func _stop_fire() -> void:
	timer.stop()
	shader_mat.set_shader_parameter("time_scale", 1.)
	modulate.a = .5

