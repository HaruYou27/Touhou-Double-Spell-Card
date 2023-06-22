extends Node2D

@onready var timer : Timer = $Timer
@onready var orb1 := $bullet/YinyangOrb
@onready var orb2 := $bullet/YinyangOrb2

func _open_fire() -> void:
	timer.start()
		
func _stop_fire() -> void:
	timer.stop()
