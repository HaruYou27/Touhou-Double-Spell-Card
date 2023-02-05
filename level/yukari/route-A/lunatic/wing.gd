extends Node2D

onready var bullet2 := $bullet2
onready var bullet := $bullet

func _ready():
	set_physics_process(false)
	var rand := randf() * TAU
	bullet.rotation = rand
	bullet2.rotation = rand
	
func start():
	$Timer.start()
	set_physics_process(true)
	show()
	
func _physics_process(delta):
	var phi :float = delta * PI/2
	bullet2.rotation += phi
	bullet.rotation -= phi
