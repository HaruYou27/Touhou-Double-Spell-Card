extends Position2D
class_name TargetLocker

export (int) var mass := 1

onready var target :Node2D = Global.player

func _physics_process(_delta):
	var desired_angle = global_position.angle_to_point(target.global_position)
	rotation += (desired_angle - rotation) / mass
