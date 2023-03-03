extends Node2D
class_name TargetLocker

func _physics_process(_delta):
	rotation = global_position.angle_to_point(Global.player.global_position)
