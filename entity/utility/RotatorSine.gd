extends Rotator
class_name RotatorSine
## Should only be use on bosses.

@export var frequency := 1.0
@onready var speed_base := speed

func _physics_process(delta: float) -> void:
	speed = sin(Time.get_ticks_msec() * frequency * 0.001) * speed_base
	super(delta)
