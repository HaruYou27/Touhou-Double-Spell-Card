extends StaticBody2D

func _ready() -> void:
	if not is_multiplayer_authority():
		return
	Global.bullet_graze.connect(_graze)
	
@onready var vfx: GPUParticles2D = $vfx
@onready var sfx: AudioStreamPlayer = $sfx
func _graze() -> void:
	if not is_multiplayer_authority():
		return
		
	sfx.play()
	vfx.emitting = true
