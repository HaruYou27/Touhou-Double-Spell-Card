extends Node

onready var parent : Node2D = get_parent()
onready var focus_speed :int = parent.speed / 2

func _physics_process(_delta) -> void:
	var mouse_local := parent.get_local_mouse_position()
	
	if not mouse_local.x:
		return
	
	if mouse_local.length() <= focus_speed:
		Input.action_press("focus")
	else:
		Input.action_release("focus")
	
	var mouse_global := parent.get_global_mouse_position()
	var angle := parent.global_position.angle_to_point(mouse_global)
	
	parent.global_position = mouse_global.posmodv(Global.playground)
