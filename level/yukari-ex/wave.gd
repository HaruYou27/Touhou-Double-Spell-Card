extends Node2D

onready var bullet := $bullet

func start():
	set_physics_process(true)
	
func _physics_process(delta):
	bullet.rotation += PI / 4 * delta
