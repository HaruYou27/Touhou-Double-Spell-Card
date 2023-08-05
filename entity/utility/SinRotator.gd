extends Marker2D
class_name SinRotator

@export var min_rad := 0.
@export var max_rad := TAU
func transform_barrel() -> void:
	rotation = min_rad + abs(sin(position.length())) * (max_rad - min_rad)
	
