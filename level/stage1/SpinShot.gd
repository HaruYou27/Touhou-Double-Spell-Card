extends Node2D

@export var clockwise : Node2D
@export var counter_clockwise : Node2D

func _physics_process(delta:float) -> void:
	clockwise.rotation += TAU * delta
	counter_clockwise.rotation += TAU * -delta
