extends Node2D
class_name LockedNode2D

@export (int) var value
@export (bool) var locked_y

func _notification(what):
	if what != CanvasItem.NOTIFICATION_TRANSFORM_CHANGED:
		return
	
	if locked_y:
		global_position.y = value
	else:
		global_position.x = value

func _ready():
	set_notify_transform(true)
