extends Node2D
class_name TargetLocker

func transform_barrel() -> void:
	rotation = GlobalItem.get_nearest_player(global_position).angle()
