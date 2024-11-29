extends Area2D

@onready var tree := get_tree()
@onready var timer: Timer = $Timer
@onready var tail_particles: GPUParticles2D = $tail
@onready var seal_particles: GPUParticles2D = $sealParticles
@onready var seal_particles_fb: CPUParticles2D = $sealParticles
@onready var explosion: GPUParticles2D = $explosion

func _ready() -> void:
	toggle(false)

func toggle(on:=true) -> void:
	tail_particles.emitting = on
	seal_particles.emitting = on
	seal_particles_fb.emitting = on
	monitoring = on
	set_physics_process(on)
	
@export var speed := 500.0
var index := 0
func _physics_process(delta: float) -> void:
	var targets := get_overlapping_areas()
	if has_overlapping_areas():
		global_position.y -= speed * delta
		return
	
	var target:Enemy = targets[index]
	while target.collision_layer:
		index += 1
		if index == targets.size():
			explode()
		target = targets[index]
	global_position += speed * delta * (target.global_position - global_position).normalized()

func explode(_nm=null) -> void:
	monitorable = true
	explosion.emitting = true
	
	toggle(false)
	timer.start()
