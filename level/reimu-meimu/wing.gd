extends ColorRect

onready var meimu :Area2D = $meimu
onready var barrel :Node2D = $meimu/bullet
onready var barrel2 :Node2D = $meimu/bullet2

func _ready() -> void:
	randomize()
	var phi = randf() * TAU
	barrel.rotation = phi
	barrel2.rotation = phi

func _physics_process(delta) -> void:
	barrel.rotation += 0.897 * delta
	barrel2.rotation -= 0.897 * delta
