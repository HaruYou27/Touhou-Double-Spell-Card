extends BulletBasic
class_name Seeker

@export_flags_2d_physics var seek_mask := 0
@export var seek_radius := 10.
var seek_query = PhysicsShapeQueryParameters2D.new()
var seek_shape = PhysicsServer2D.circle_shape_create()

@export var hit_particle : GPUParticles2D

func _ready() -> void:
	seek_query.shape_rid = seek_shape;
	PhysicsServer2D.shape_set_data(seek_shape, seek_radius);
	seek_query.collide_with_areas = collide_with_areas;
	seek_query.collide_with_bodies = collide_with_bodies;
	seek_query.collision_mask = seek_mask;
	super()

func collide(result:Dictionary) -> bool:
	#Return true means the bullet will still alive.
	if int(result["linear_velocity"].x) == -1:
		#Hit the wall.
		return false;
	
	var collider = instance_from_id(result["collider_id"])
	collider.call("_hit")
	hit_particle.emit_particle(bullet.transform, Vector2.ZERO, Color.WHITE, Color.WHITE, 1)
	return false;

func _exit_tree() -> void:
	super()
	PhysicsServer2D.free_rid(seek_shape)
	
func move(delta:float) -> Transform2D:
	
	seek_query.transform = Transform2D(0, bullet.transform.origin)
	var seek_result = world.direct_space_state.get_rest_info(seek_query)
	if seek_result.is_empty():
		return super(delta)
		
	var target = instance_from_id(seek_result["collider_id"])
	bullet.velocity = (target.global_position - bullet.transform.origin).normalized() * speed
	bullet.transform = Transform2D(bullet.velocity.angle() + PI /2, bullet.transform.origin + bullet.velocity * delta)
	return bullet.transform
