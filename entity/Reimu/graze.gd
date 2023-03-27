extends StaticBody2D

@onready var graze_fx : GPUParticles2D = $grazeFX
@onready var graze_timer : Timer = $grazeFX/Timer

func _ready() -> void:
	Global.bullet_graze.connect(Callable(self,'_graze'))
	
func _graze() -> void:
	graze_fx.emitting = true
	graze_timer.start()
