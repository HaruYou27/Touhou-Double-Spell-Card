extends Node
class_name MouseInput

onready var player : Node2D = get_parent()

var focus_speed :int = 172

func _physics_process(_delta):
	var mouse_local := player.get_local_mouse_position()
	var mouse_global :Vector2 = Global.get_global_mouse_position()
	
	if not mouse_local.x:
		return
	var angle = mouse_local.angle()
	
	player.global_position = mouse_global
	player.position.x = clamp(player.position.x, 0.0, 646.0)
	player.position.y = clamp(player.position.y, 0.0, 904.0)
