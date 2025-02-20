@tool
extends CPUparticles

func _ready() -> void:
	color.h = absf(sin(Time.get_ticks_usec()))
	if Engine.is_editor_hint():
		return
	super()
