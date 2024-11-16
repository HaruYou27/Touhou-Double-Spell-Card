extends BulletBasic
class_name Ricochetor

@export var ricochet := 1

func create_bullet() -> Bullet:
	var bullet := RicochetBullet.new()
	bullet.ricochet = ricochet
	return bullet
	
func collide(result:Dictionary, bullet:Bullet) -> bool:
	if bullet.ricochet > 0 and (int(result["linear_velocity"].x) == 1):
		bullet.velocity = bullet.velocity.bounce(result["normal"])
		bullet.transform = Transform2D(bullet.velocity.angle() + half_pi, bullet.transform.origin)
		
		bullet.ricochet -= 1
		return true
	
	return super(result, bullet)
