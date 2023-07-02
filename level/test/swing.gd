extends Node2D

@onready var clockwise := $clockwise
var signed := 1
func _on_timer_timeout() -> void:
	clockwise.rotation += TAU * .1 * signed

func _on_cycle_timeout() -> void:
	signed *= -1
