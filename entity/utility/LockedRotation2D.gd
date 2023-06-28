extends Sprite2D
class_name LockedRotation2D
##Remain fixed at a value in 1 axie.

##The fixed value.
@export var value := 0

func _physics_process(_delta) -> void:
	global_rotation = value
