extends GPUParticles2D

signal finished

@onready var sfx := $sfx
func explode() -> void:
	sfx.play()
	emitting = true

func _on_timer_timeout():
	finished.emit()
