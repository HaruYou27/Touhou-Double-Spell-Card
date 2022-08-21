extends Node

onready var parent : Node2D = get_parent()
onready var focus_speed :int = parent.speed / 2

func _unhandled_input(event:InputEvent) -> void:
	if not event is InputEventScreenDrag:
		parent.focus = false
		return
	
	if event.relative <= focus_speed:
		Input.action_press("focus")
	else:
		Input.action_release("focus")
	parent.global_position += event.relative
	parent.global_position = parent.global_position.posmodv(Global.playground)
