extends Node

onready var player : Node2D = get_parent()
onready var focus_speed :int = player.speed / 4

func _unhandled_input(event:InputEvent) -> void:
	if not event is InputEventScreenDrag:
		player.focus = false
		return
	
	var deltaPosition = event.relative
	if deltaPosition <= focus_speed:
		Input.action_press("focus")
	else:
		Input.action_release("focus")
	var angle = deltaPosition.angle()
	
	player.position += deltaPosition
	player.position.x = clamp(player.position.x, 0.0, 646.0)
	player.position.y = clamp(player.position.y, 0.0, 904.0)
