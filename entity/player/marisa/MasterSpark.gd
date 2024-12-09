extends Node2D

@onready var animator := $AnimationPlayer
@onready var rays : Array[RayCast2D]
@onready var beam := $Beam
func _ready():
	rays.append($RayCast2D)
	rays.append_array(rays[0].get_children())
	
@onready var beam_particle: GPUParticles2D = $Beam/BeamParticle
@onready var collision_particle: GPUParticles2D = $Beam/CollisionParticle
@onready var collision_particle_fb: CPUParticles2D = $Beam/CollisionParticle2

## Avoid cheating by increase physics step.
var cooldown := .0
var is_colliding := false

func _physics_process(delta:float) -> void:
	if cooldown >= 0:
		cooldown -= delta
	is_colliding = false
	
	for ray in rays:
		if not ray.is_colliding():
			continue
			
		var collider := ray.get_collider()
		if is_multiplayer_authority():
			collider.hit.call_deferred()
		
		# The code below should only run 1 per frame at most.
		if is_colliding:
			continue
		cooldown += 0.025
		is_colliding = true
		collision_particle.show()
		collision_particle.global_position.y = collider.global_position.y
		beam.points[1].y = collision_particle.position.y
		beam_particle.position.y = collision_particle.position.y / 2
		beam_particle.process_material.emission_box_extents.y = beam_particle.position.y
		
	if not is_colliding:
		collision_particle.hide()
		beam.points[1].y = -960
		beam_particle.position.y = -480
		beam_particle.process_material.emission_box_extents.y = -960

@onready var spark_hitbox := $Spark/SparkHitbox
func _on_player_kaboom(offset:float) -> void:
	set_physics_process(false)
	animator.play("Master Spark")
	spark_hitbox.set_deferred("disabled", false)
	ScreenEffect.shake(6.0)
	
signal finished
func _on_animation_player_animation_finished(_anim_name):
	spark_hitbox.set_deferred("disabled", true)
	finished.emit()
	set_physics_process(true)
