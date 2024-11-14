extends AcceleratorSmooth
class_name AcceleratorEase

@export var ease_curve := 1.0

func calculate_speed(life_time:float) -> float:
	return ease(life_time, ease_curve) * accel + speed
