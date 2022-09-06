extends Node

onready var player : Node2D = get_parent()

var focus_speed :int = 172

func _physics_process(_delta) -> void:
	var mouse_local := player.get_local_mouse_position()
	var mouse_global := Global.get_global_mouse_position()
	
	if not mouse_local.x:
		return
	
	if mouse_local.length() <= focus_speed:
		Input.action_press("focus")
	else:
		Input.action_release("focus")
	var angle = mouse_local.angle()
	
	player.global_position = mouse_global
	player.position.x = clamp(player.position.x, 0.0, 646.0)
	player.position.y = clamp(player.position.y, 0.0, 904.0)
