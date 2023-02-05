extends Node2D

onready var bullet :Node2D = $bullet3
onready var bullet2 :Node2D = $bullet2

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	var phi :float = PI * delta
	bullet.rotation += phi
	bullet2.rotation -= phi

func start():
	$Timer.start()
	set_physics_process(true)
