extends Area2D
class_name FantasySeal

@onready var tree := get_tree()
@onready var tail_particles: GPUParticles2D = $tail
@onready var seal_particles: GPUParticles2D = $sealParticles
@onready var seal_particles_fb: CPUParticles2D = $sealParticles2
@onready var explosion: GPUParticles2D = $explosion

@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var seek: CollisionShape2D = $CollisionShape2D
@onready var explode_physics: CollisionShape2D = $ExplodeBody/CollisionShape2D

func _ready() -> void:
	toggle(false)

func toggle(on:=true) -> void:
	tail_particles.emitting = on
	seal_particles.emitting = on
	seal_particles_fb.emitting = on
	set_physics_process(on)
	hitbox.set_deferred("disabled", not on)
	seek.set_deferred("disabled", not on)
	
	target_vaild = false
	target = null
	
var target: Enemy
var target_vaild := false
func _on_area_entered(area: Area2D) -> void:
	if target_vaild:
		return
	target = area
	
@export var speed := 527.0
func _physics_process(delta: float) -> void:
	target_vaild = target and target.hp
	if not target_vaild:
		global_position.y -= speed * delta
		return
	global_position += speed * delta * (target.global_position - global_position).normalized()

func explode(_nm=null) -> void:
	OS.delay_msec(16)
	ScreenEffect.screen_shake(0.6)
	ScreenEffect.flash(0.3)
	explosion.emitting = true
	explode_physics.set_deferred("disabled", false)
	toggle(false)
