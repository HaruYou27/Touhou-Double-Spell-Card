extends AcceleratorLinear
class_name AcceleratorSmooth

@onready var accel := speed2 - speed

func calculate_speed(life_time:float) -> float:
	return smoothstep(0, duration, life_time) * accel + speed
