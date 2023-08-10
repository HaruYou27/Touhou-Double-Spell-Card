extends BulletBasic
class_name Seeker

@export_category("Seek behavior")
@export_flags_2d_physics var seek_mask := 2
var seek_query := PhysicsShapeQueryParameters2D.new()
@export var seek_shape : CircleShape2D

func _ready() -> void:
	seek_query.shape = seek_shape;
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
	
	return false;
	
func create_bullet() -> void:
	bullet = SeekerBullet.new()
	
func move(delta:float, bullete:Bullet) -> void:
	if bullete.target.y:
		bullete.velocity = (bullete.target - bullete.transform.origin).normalized() * speed
		bullete.transform = Transform2D(bullete.velocity.angle() + half_pi, bullete.transform.origin)
	super(delta, bullete)

func collision_check() -> void:
	seek_query.transform = bullet.transform
	var seek_result = world.direct_space_state.get_rest_info(seek_query)
	if seek_result.is_empty():
		bullet.target = Vector2.ZERO
		return
	bullet.target = seek_result["point"]
