extends StaticBody2D

@onready var vfx : GPUParticles2D = $grazeFX
@onready var timer : Timer = $vfx/Timer
@onready var sfx : AudioStreamPlayer = $sfx

func _ready() -> void:
	Global.bullet_graze.connect(Callable(self,'_graze'))
	
func _graze() -> void:
	vfx.emitting = true
	sfx.play()
	timer.start()
