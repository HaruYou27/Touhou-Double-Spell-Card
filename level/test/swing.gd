extends Node2D

@onready var clockwise := $clockwise
var sign := 1
func _on_timer_timeout() -> void:
	clockwise.rotation += TAU * .1 * sign

func _on_cycle_timeout() -> void:
	sign *= -1
