extends Node
class_name TimerPrecise

signal timeout

@export var wait_time := 1.0

@onready var time := wait_time
func _process(delta: float) -> void:
	time -= delta
	if time < 0:
		time = wait_time
		timeout.emit()
