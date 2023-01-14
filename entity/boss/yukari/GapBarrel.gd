extends LockedNode2D

export (int) var offset_strength := 172
export (float) var speed_mod := 0.002

onready var ran_val := randi()

func _physics_process(delta:float):
	var offset := sin((Time.get_ticks_msec() + ran_val) * speed_mod) * delta * offset_strength
	if locked_y:
		position.x += offset
	else:
		position.y += offset
