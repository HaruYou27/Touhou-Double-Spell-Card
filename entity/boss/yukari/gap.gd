extends LockedNode2D

onready var ran_val := randf()

func lock_axie():
	var offset := sin(Time.get_ticks_msec()) + ran_val
	if locked_y:
		global_position.y = value
		position.x += offset
	else:
		global_position.x = value
		position.y += offset
