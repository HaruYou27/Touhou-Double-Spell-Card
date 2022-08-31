extends Node

onready var parent : Node2D = get_parent()
onready var focus_speed :int = parent.speed / 2

func _unhandled_input(event:InputEvent) -> void:
	if not event is InputEventScreenDrag:
		parent.focus = false
		return
	
	var deltaPosition = event.relative
	if deltaPosition <= focus_speed:
		Input.action_press("focus")
	else:
		Input.action_release("focus")
	var angle = deltaPosition.angle()
	
	parent.position += deltaPosition
	parent.position = parent.position.posmodv(Global.playground)
