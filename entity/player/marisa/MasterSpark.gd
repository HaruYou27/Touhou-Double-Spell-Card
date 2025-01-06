extends Node2D

@onready var animator := $AnimationPlayer
@onready var rays : Array[RayCast2D]
@onready var beam := $Beam
var ray_query := PhysicsRayQueryParameters2D.new()
@export var collide_areas := true
@export var collide_bodies := false
@export_flags_2d_physics var collision_layer := 2
@onready var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
var index_max := 0
func _ready():
	rays.append($RayCast2D)
	rays.append_array(rays[0].get_children())
	index_max = rays.size()
	ray_query.collide_with_areas = collide_areas
	ray_query.collide_with_bodies = collide_bodies
	ray_query.collision_mask = collision_layer
	
@onready var beam_particle: GPUParticles2D = $Beam/BeamParticle
@onready var collision_particle: GPUParticles2D = $Beam/CollisionParticle
@onready var collision_particle_fb: CPUParticles2D = $Beam/CollisionParticle2

## Avoid cheating by increase physics step.
var cooldown := .0
var index := 0

const ray_length = Vector2(0, -960)

func _physics_process(delta:float) -> void:
	if cooldown >= 0:
		cooldown -= delta
		return
		
	if index == index_max:
		index = 0
	ray_query.from = rays[index].global_position
	index += 1
	ray_query.to = ray_query.from + ray_length
	var result = space.intersect_ray(ray_query)
	if result.is_empty():
		collision_particle.hide()
		beam.points[1].y = -960
		beam_particle.position.y = -480
		beam_particle.process_material.emission_box_extents.y = -960
		return
		
	var collider: Node2D = result["collider"]
	collider.hit.call_deferred()
	cooldown += 0.025
	collision_particle.show()
	collision_particle.global_position.y = collider.global_position.y
	beam.points[1].y = collision_particle.position.y
	beam_particle.position.y = collision_particle.position.y / 2
	beam_particle.process_material.emission_box_extents.y = beam_particle.position.y

func _on_player_kaboom() -> void:
	set_physics_process(false)
	animator.play("Master Spark")
	ScreenEffect.shake(6.0)
	
func _on_animation_player_animation_finished(_nm):
	set_physics_process(true)
