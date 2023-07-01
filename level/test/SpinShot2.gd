extends Node2D

@onready var clockwise := $clockwise
@onready var counter_clockwise := $CounterClockwise
func _on_timer_timeout() -> void:
	clockwise.rotation += TAU * .1
	counter_clockwise.rotation -= TAU * .1
