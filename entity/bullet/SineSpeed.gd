extends BulletBasic
class_name SineSpeed
##Bullet that speed up and down by sine wave.
	
@export var frequency := 1.

func create_bullet() -> void:
	bullet = AgedBullet.new()
	
func move(delta:float, bullete:Bullet) -> void:
	bullet.age += delta * frequency
	bullet.velocity = bullet.velocity.normalized() * speed * abs(sin(bullet.age))
	
	return super(delta, bullete)
