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

func collide(result:Dictionary, _bullet:Bullet) -> bool:
	#Return true means the bullet will still alive.
	if int(result["linear_velocity"].x) == -1:
		#Hit the wall.
		return false
	
	if not is_multiplayer_authority():
		return true
		
	var collider = instance_from_id(result["collider_id"])
	collider.call("_hit")
	
	return false;
	
func create_bullet() -> Bullet:
	return SeekerBullet.new()
	
func move(delta:float, bullet:Bullet) -> void:
	if bullet.target.y:
		bullet.velocity = (bullet.target - bullet.transform.origin).normalized() * speed
		bullet.transform = Transform2D(bullet.velocity.angle() + half_pi, bullet.transform.origin)
	super(delta, bullet)


func collision_check(bullet:Bullet) -> bool:
	seek_query.transform = bullet.transform
	var seek_result = world.direct_space_state.get_rest_info(seek_query)
	if seek_result.is_empty():
		bullet.target = Vector2.ZERO
		return super(bullet)
	bullet.target = seek_result["point"]
	return super(bullet)
	
