extends Area2D
class_name FantasySeal

@onready var tree := get_tree()
@onready var tail_particles: GPUParticles2D = $tail
@onready var seal_particles: GPUParticles2D = $sealParticles
@onready var seal_particles_fb: CPUParticles2D = $sealParticles2
@onready var explosion: GPUParticles2D = $explosion

## It's more convenient this way.
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var seek: CollisionShape2D = $CollisionShape2D
@onready var explode_physics: Node = $ExplodeBody

func _ready() -> void:
	toggle.call_deferred(false)
	toggle_explode.call_deferred(false)

func toggle(on:bool) -> void:
	velocity = Vector2.UP * speed
	tail_particles.emitting = on
	seal_particles.emitting = on
	seal_particles_fb.emitting = on
	set_physics_process(on)
	
	hitbox.disabled = not on
	seek.disabled = not on
	
	target_vaild = false
	target = null
	
var target: Area2D
var target_vaild := false
func _on_area_entered(area: Area2D) -> void:
	if target_vaild:
		return
	target = area
	
@export var speed := 527.0
@export var speed_turn := 727.0
@onready var velocity := Vector2.UP * speed
func _physics_process(delta: float) -> void:
	target_vaild = target and target.monitorable
	if target_vaild:
		velocity += (target.global_position - global_position).normalized() * speed_turn
		velocity = velocity.normalized() * speed
	
	global_position += delta * velocity
 
func explode(_nm=null) -> void:
	OS.delay_msec(16)
	ScreenEffect.flash(0.3)
	ScreenEffect.shake(0.3)
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
