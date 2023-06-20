extends Node2D

@onready var animator := $AnimationPlayer
@onready var rays : Array[RayCast2D]
@onready var beams : Array[Line2D]

func _ready():
	rays.append($RayCast2D)
	rays.append_array(rays[0].get_children())
	
	beams.append($beam2)
	beams.append_array(beams[0].get_children())
	
	set_physics_process(false)

@onready var beam_particle : GPUParticles2D = $BeamParticle
@onready var collision_particle := $beam2/glow2/CollisionParticle
var cooldown := .0
func _physics_process(delta:float) -> void:
	if cooldown >= 0:
		cooldown -= delta
	
	for ray in rays:
		if ray.is_colliding():
			collision_particle.global_position.y = ray.get_collision_point().y
			for beam in beams:
				beam.points[1].y = abs(collision_particle.position.y)
			beam_particle.position.y = collision_particle.position.y / 2
			beam_particle.process_material.emission_box_extents.y = beam_particle.position.y
			
			if cooldown <= 0:
				ray.get_collider()._hit()
				cooldown += 0.033333333333333
			return
			
@onready var spark_timer := $Spark/SparkTimer
@onready var spark_hitbox := $Spark/SparkHitbox
func _on_player_kaboom() -> void:
	_on_player_stop_fire()
	animator.play("Master Spark")	
	spark_timer.start()
	spark_hitbox.set_deferred("disabled", false)
	
func _bomb_finished() -> void:
	_on_player_open_fire()
	animator.play_backwards("Master Spark")
	spark_hitbox.set_deferred("disabled", true)

func _on_player_open_fire() -> void:
	set_physics_process(true)
	animator.play("open_fire")
	for ray in rays:
		ray.enabled = true

func _on_player_stop_fire() -> void:
	set_physics_process(false)
	animator.play_backwards("open_fire")
	for ray in rays:
		ray.enabled = false
