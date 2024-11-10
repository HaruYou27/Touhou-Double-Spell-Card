extends BulletBasic
class_name Accelerator

@export var speed2 := 727.0
@export var duration := 2.0
@onready var accel := (speed2 - speed) / duration

func create_bullet() -> Bullet:
	return AgedBullet.new()

func move(delta:float, bullet:Bullet):
	bullet.age += delta
	
