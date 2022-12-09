extends ColorRect

onready var bullet :Node2D = $bullet
onready var bullet2 :Node2D = $bullet2

func _physics_process(delta):
	var phi :float = 0.897 * delta
	bullet.rotation += phi
	bullet2.rotation -= phi

func _start():
	bullet.set_physics_process(true)
	bullet2.set_physics_process(true)
	set_physics_process(true)
