extends Node2D
class_name TargetLocker

func _ready():
	Global.connect("player_moved", self, "aim")

func aim(pos):
	rotation = global_position.angle_to_point(pos)
