extends Area2D

@onready var tree := get_tree()
@onready var timer: Timer = $Timer
@onready var tail_particles: GPUParticles2D = $tail
@onready var seal_particles: GPUParticles2D = $sealParticles
@onready var explosion: GPUParticles2D = $explosion
func _ready() -> void:
	tail_particles.emitting = false
	seal_particles.emitting = false
	monitoring = false
	set_physics_process(false)
	
func start() -> void:
	tail_particles.emitting = true
	seal_particles.emitting = true
	monitoring = true
	set_physics_process(true)
	
@export var speed := 500.0
var index := 0
func _physics_process(delta: float) -> void:
	var targets := get_overlapping_areas()
	if has_overlapping_areas():
		global_position.y -= speed * delta
		return
	
	var target:Enemy = targets[index]
	while target.is_dead:
		index += 1
		if index == targets.size():
			explode()
		target = targets[index]
	global_position += speed * delta * (target.global_position - global_position).normalized()

func explode(_nm=null) -> void:
	monitorable = true
	explosion.emitting = true
	
	set_physics_process(false)
	monitoring = false
	seal_particles.emitting = false
	tail_particles.emitting = false
