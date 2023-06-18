extends StaticBody2D

func _ready() -> void:
	if is_multiplayer_authority():
		Global.bullet_graze.connect(_graze)
	
@onready var vfx : GPUParticles2D = $vfx
@onready var timer : Timer = $vfx/Timer
@onready var sfx : AudioStreamPlayer = $sfx
func _graze() -> void:
	vfx.emitting = true
	sfx.play()
	timer.start()
