extends Position2D

onready var target :Node2D = Global.player

func _process(_delta):
	rotation = global_position.angle_to_point(target.global_position)
