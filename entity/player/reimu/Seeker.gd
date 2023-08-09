extends BulletBasic
class_name Seeker

@export var hit_particle : GPUParticles2D

@export_category("Seek behavior")
@export_flags_2d_physics var seek_mask := 2
var seek_query = PhysicsShapeQueryParameters2D.new()
@export var seek_radius := 270.0
var seek_shape = PhysicsServer2D.circle_shape_create()

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
	
func move(delta:float, bullete:Bullet) -> void:
	bullete.velocity = bullete.velocity.normalized() * speed
	bullete.transform = Transform2D(bullete.velocity.angle() + half_pi, bullete.transform.origin + bullete.velocity * delta)
	RenderingServer.canvas_item_set_transform(bullete.sprite, query.transform)
	super(delta, bullete)

func collision_check() -> void:
	seek_query.transform = bullet.transform
	var seek_result = world.direct_space_state.get_rest_info(seek_query)
	if not seek_result.is_empty():
		bullet.velocity = seek_result["point"] - bullet.transform.origin
