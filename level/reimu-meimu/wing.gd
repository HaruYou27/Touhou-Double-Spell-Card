extends ColorRect

onready var meimu :Area2D = $meimu
onready var bullet :Node2D = $meimu/bullet
onready var bullet2 :Node2D = $meimu/bullet2

func _ready():
	bullet.set_physics_process(false)
	bullet2.set_physics_process(false)
	set_physics_process(false)
	
func _physics_process(delta):
	var phi :float = 0.897 * delta
	bullet.rotation += phi
	bullet2.rotation -= phi

func _start():
	bullet.set_physics_process(true)
	bullet2.set_physics_process(true)
	set_physics_process(true)
