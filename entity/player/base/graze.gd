extends StaticBody2D

	
@onready var vfx: GPUParticles2D = $vfx
@onready var sfx: AudioStreamPlayer = $sfx
@onready var hud: HUD = Global.hud
func hit() -> void:
	if not is_multiplayer_authority():
		return
		
	sfx.play()
	vfx.emitting = true
	hud.add_graze()

func item_collect() -> void:
	if not is_multiplayer_authority():
		return
		
	hud.add_item()
