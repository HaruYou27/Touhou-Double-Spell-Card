extends ColorRect

onready var meimu :Area2D = $meimu
onready var barrel :Node2D = $meimu/bullet
onready var barrel2 :Node2D = $meimu/bullet2

func _physics_process(delta) -> void:
	barrel.rotation += 0.897 * delta
	barrel2.rotation -= 0.897 * delta
