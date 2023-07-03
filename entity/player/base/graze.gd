extends StaticBody2D

func _ready() -> void:
	if is_multiplayer_authority():
		Global.bullet_graze.connect(_graze)
	else:
		queue_free()
	
@onready var vfx : GPUParticles2D = $vfx
@onready var sfx : AudioStreamPlayer = $sfx
func _graze() -> void:
	vfx.emitting = true
	sfx.play()
