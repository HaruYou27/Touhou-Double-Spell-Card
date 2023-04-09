extends StaticBody2D

@onready var vfx : GPUParticles2D = $vfx
@onready var timer : Timer = $vfx/Timer
@onready var sfx : AudioStreamPlayer = $sfx

func _ready() -> void:
	Global.bullet_graze.connect(_graze)
	
func _graze() -> void:
	vfx.emitting = true
	sfx.play()
	timer.start()
