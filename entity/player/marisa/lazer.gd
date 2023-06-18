extends Node2D

@onready var ray1 := $RayCast2D
@onready var ray2 := $RayCast2D2
@onready var timer : Timer = $Timer
func _on_player_open_fire():
	ray1.enabled = true
	ray2.enabled = true
	timer.start()

func _on_player_stop_fire():
	ray1.enabled = false
	ray2.enabled = false
	timer.stop()

func _on_timer_timeout():
	if ray1.is_colliding():
		ray1.get_collider()._hit()
	
	if ray2.is_colliding():
		ray2.get_collider()._hit()
