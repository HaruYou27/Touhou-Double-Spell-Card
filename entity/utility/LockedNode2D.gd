extends Node2D
class_name LockedNode2D

export (int) var value
export (bool) var locked_y
export (bool) var sync_physics := false

func _ready():
	set_process(not sync_physics)
	set_physics_process(sync_physics)
	
func lock_axie():
	if locked_y:
		global_position.y = value
	else:
		global_position.x = value
	
func _process(_delta):
	lock_axie()
	
func _physics_process(_delta):
	lock_axie()
