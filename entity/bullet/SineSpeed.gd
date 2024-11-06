extends BulletBasic
class_name SineSpeed
##Bullet that speed up and down by sine wave.
	
@export var frequency := 1.

func create_bullet() -> Bullet:
	return AgedBullet.new()
	
func move(delta:float, bullete:Bullet) -> void:
	bullete.age += delta * frequency
	bullete.velocity = bullete.velocity.normalized() * speed * abs(sin(bullete.age))
	
	return super(delta, bullete)
