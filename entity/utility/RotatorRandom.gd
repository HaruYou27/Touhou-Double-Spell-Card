extends Marker2D
class_name RotatorRandom
## Only works with moving entity.

@export var min_rad := 0.
@export var max_rad := TAU
## Use global position so that i don't have to sync over network.
func transform_barrel() -> void:
	rotation = min_rad + abs(sin(global_position.length())) * (max_rad - min_rad)
	
