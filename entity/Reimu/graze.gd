extends StaticBody2D

@onready var graze_fx : GPUParticles2D = $graze/grazeFX
@onready var graze_timer : Timer = $graze/grazeFX/Timer

func _ready() -> void:
	Global.connect("bullet_graze",Callable(self,'_graze'))
	graze_timer.connect("timeout",Callable(graze_fx,'set_emitting').bind(false))
	
func _graze() -> void:
	graze_fx.emitting = true
	graze_timer.start()
