extends FantasySeal
@onready var tail_particles: GPUParticles2D = $tail
@onready var seal_particles: GPUParticles2D = $sealParticles
@onready var seal_particles_fb: CPUParticles2D = $sealParticles2
@onready var explosion: GPUParticles2D = $explosion
@onready var explosion_fb: CPUParticles2D = $explosion2

## It's more convenient this way.
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var explode_physics: Node = $ExplodeBody

func _ready() -> void:
	toggle.call_deferred(false)
	toggle_explode.call_deferred(false)

func toggle(on:bool) -> void:
	tail_particles.emitting = on
	seal_particles.emitting = on
	seal_particles_fb.emitting = on
	set_physics_process(on)
	
	hitbox.disabled = not on
	toggle_internal(on)
	
	target_vaild = false
	target = null
	
var target: Area2D
var target_vaild := false
func _on_area_entered(area: Area2D) -> void:
	if target_vaild:
		return
	target = area
 
func explode(_nm=null) -> void:
	ScreenVFX.flash(0.3)
	ScreenVFX.shake(0.3)
	explosion.emitting = true
	toggle.call_deferred(false)
	toggle_explode.call_deferred(true)

func _on_hitbox_body_entered(_body: Node2D) -> void:
	toggle.call_deferred(false)

func _on_explosion_finished() -> void:
	toggle_explode.call_deferred(false)
	
func toggle_explode(on:bool) -> void:
	if on:
		explode_physics.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		explode_physics.process_mode = Node.PROCESS_MODE_DISABLED
