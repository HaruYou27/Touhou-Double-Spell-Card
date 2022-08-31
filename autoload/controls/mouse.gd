extends Node

onready var player : Node2D = get_parent()
onready var playground : Control = player.get_parent()
onready var focus_speed :int = player.speed / 2

func _physics_process(_delta) -> void:
	var mouse_local := player.get_local_mouse_position()
	var mouse_global := playground.get_local_mouse_position()
	
	if not mouse_local.x:
		return
	
	if mouse_local.length() <= focus_speed:
		Input.action_press("focus")
	else:
		Input.action_release("focus")
	var angle = mouse_local.angle()
	
	parent.position.x = clamp(parent.position.x, 0.0, 646.0)
	parent.position.y = clamp(parent.position.y, 0.0, 904.0)
