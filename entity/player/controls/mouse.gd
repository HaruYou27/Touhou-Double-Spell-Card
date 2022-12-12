extends Node
class_name MouseInput

onready var player : Node2D = get_parent()

func _ready():
	Global.connect("bomb", self, "set_physics_process", [true])

func _physics_process(_delta):
	var mouse_local := player.get_local_mouse_position()
	if not mouse_local:
		return
	
	player.global_position = player.get_global_mouse_position()
	player.position.x = clamp(player.position.x, 0.0, 646.0)
	player.position.y = clamp(player.position.y, 0.0, 904.0)

func death_door():
	set_physics_process(false)
