extends Node2D

onready var bullet := $bullet

func _ready():
	set_physics_process(false)

func start():
	set_physics_process(true)
	$Timer.start()
	show()
	
func _physics_process(delta):
	bullet.rotation += PI / 2 * delta
