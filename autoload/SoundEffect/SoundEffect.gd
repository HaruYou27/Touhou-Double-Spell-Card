extends Node

@onready var tick0 : AudioStreamPlayer = $tick0
@onready var press0 : AudioStreamPlayer = $press0
@onready var press1 : AudioStreamPlayer = $press1


func hover() -> void:
	tick0.play()

func press(pitch:bool) -> void:
	if pitch:
		press1.play()
	else:
		press0.play()
