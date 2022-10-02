extends ColorRect

onready var meimu :Area2D = $meimu
onready var bullet :Node2D = $meimu/bullet
onready var bullet2 :Node2D = $meimu/bullet2

func _ready() -> void:
	bullet.set_physics_process(false)
	bullet2.set_physics_process(false)
	set_physics_process(false)
	
	Global.connect("impact", self, 'bomb')
	bullet.rotation = rand_range(.785, 2.356)
	if randi() % 2:
		bullet.rotation *= -1
	bullet2.rotation = bullet.rotation

func _physics_process(delta) -> void:
	bullet.rotation += 0.897 * delta
	bullet2.rotation -= 0.897 * delta
	
func bomb() -> void:
	bullet.Flush()
	bullet2.Flush()
	
func _start() -> void:
	bullet.set_physics_process(true)
	bullet2.set_physics_process(true)
	set_physics_process(true)
