extends BulletBasic
class_name AcceleratorLinear

@export_category("Acceleration")
@export var speed2 := 727.0
@export var duration := 2.0

func create_bullet() -> Bullet:
	return AgedBullet.new()

func calculate_speed(life_time:float) -> float:
	return lerp(speed, speed2, life_time / duration)

func move(delta:float, bullet:Bullet) -> void:
	if bullet.age < duration:
		bullet.age += delta
		bullet.velocity = Vector2(calculate_speed(bullet.age), 0.0).rotated(bullet.transform.get_rotation() - half_pi)
	super(delta, bullet)
