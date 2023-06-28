extends GPUParticles2D

@onready var sfx := $sfx
func explode() -> void:
	sfx.play()
	emitting = true
