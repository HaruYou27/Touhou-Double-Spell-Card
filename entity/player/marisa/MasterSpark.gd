extends Node2D

@onready var animator := $AnimationPlayer
@onready var rays : Array[Node2D]
var ray_query := PhysicsRayQueryParameters2D.new()
@export_flags_2d_physics var collision_layer := 2
@onready var space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
var index_max := 0
func _ready():
	rays.append($RayCast2D)
	rays.append_array(rays[0].get_children())
	index_max = rays.size()
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = false
	ray_query.collision_mask = collision_layer
	
@export var collision_particle: GPUParticles2D 

## Avoid cheating by increase physics step.
#var cooldown := .0
var index := 0

const ray_length = Vector2(0, -960)

func _physics_process(_delta:float) -> void:
	#if cooldown >= 0:
	#	cooldown -= delta
	#	return
		
	index = posmod(index, rays.size())
	ray_query.from = rays[index].global_position
	index += 1
	ray_query.to = ray_query.from + ray_length
	var result = space.intersect_ray(ray_query)
	if result.is_empty():
		collision_particle.global_position = Vector2(0, 1000)
		return
		
	var collider: Node2D = result["collider"]
	collider.hit.call_deferred()
	#cooldown += 0.02
	collision_particle.global_position = collider.global_position

func _on_player_kaboom() -> void:
	set_physics_process(false)
	animator.play("Master Spark")
	ScreenEffect.shake(6.0)
	
func _on_animation_player_animation_finished(_nm):
	set_physics_process(true)
