extends ColorRect

onready var meimu :Area2D = $meimu
onready var barrel :Node2D = $meimu/bullet

func _physics_process(delta) -> void:
	barrel.rotation += 0.897 * delta
