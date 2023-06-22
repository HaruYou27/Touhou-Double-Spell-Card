extends Node2D
class_name LockedNode2D
##Remain fixed at a value in 1 axie.

##The fixed value.
@export var value := 0
@export var locked_y := false

func _physics_process(_delta) -> void:
	if locked_y:
		global_position.y = value
	else:
		global_position.x = value
