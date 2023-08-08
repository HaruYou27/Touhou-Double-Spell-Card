extends Node2D

@onready var animator := $AnimationPlayer
@onready var rays : Array[RayCast2D]
@onready var beams : Array[Line2D]
func _ready():
	rays.append($RayCast2D)
	rays.append_array(rays[0].get_children())
	
	beams.append($beam)
	beams.append_array(beams[0].get_children())
	
@onready var beam_particle : GPUParticles2D = $beam/glow/BeamParticle
@onready var collision_particle := $beam/glow/CollisionParticle
var cooldown := .0
func _physics_process(delta:float) -> void:
	if cooldown >= 0:
		cooldown -= delta
	
	for ray in rays:
		if ray.is_colliding():
			var collider := ray.get_collider()
			collision_particle.show()
			collision_particle.global_position.y = collider.global_position.y
			for beam in beams:
				beam.points[1].y = collision_particle.position.y
			beam_particle.position.y = collision_particle.position.y / 2
			beam_particle.process_material.emission_box_extents.y = beam_particle.position.y
			
			if cooldown <= 0:
				collider._hit()
				cooldown += 0.03125
			return
		else:
			collision_particle.hide()
			for beam in beams:
				beam.points[1].y = -960
			beam_particle.position.y = -480
			beam_particle.process_material.emission_box_extents.y = -960
			
			
@onready var spark_hitbox := $Spark/SparkHitbox
func _on_player_kaboom(offset:float) -> void:
	set_physics_process(false)
	animator.play("Master Spark")
	animator.seek(offset)
	spark_hitbox.set_deferred("disabled", false)
	
signal finished
func _on_animation_player_animation_finished(_anim_name):
	spark_hitbox.set_deferred("disabled", true)
	finished.emit()
	set_physics_process(true)
