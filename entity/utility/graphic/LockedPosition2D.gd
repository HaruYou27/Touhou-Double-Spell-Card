extends Sprite2D
class_name LockedPosition2D
##Remain fixed at a value in 1 axie.

##The fixed value.
@export var value := 0
@export var locked_y := false

func _process(_delta) -> void:
	if locked_y:
		global_position.y = value
	else:
		global_position.x = value
