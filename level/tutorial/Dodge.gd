extends Node2D

var difficulty_level := 0

func _ready() -> void:
	set_physics_process(false)
	
func start() -> void:
	$Timer.start()
	$bullet/Timer.start()
	set_physics_process(true)
	
func _physics_process(delta:float) -> void:
	rotation += delta * TAU

func _on_timer_timeout() -> void:
	if not difficulty_level:
		$bullet.speed = 572
