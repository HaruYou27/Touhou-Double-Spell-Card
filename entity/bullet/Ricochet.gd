extends BulletBasic

@export var ricochet := 1;

func reset_bullet() -> void:
	bullet.ricochet = ricochet
	
func collide(result:Dictionary) -> bool:
	if bullet.ricochet > 0 and (int(result["linear_velocity"].x) == 1):
		bullet.velocity = bullet.velocity.bounce(result["normal"])
		bullet.transform = Transform2D(bullet.velocity.angle() + PI / 2, bullet.transform.origin)
		bullet.ricochet -= 1
		return true
	
	return super(result)
