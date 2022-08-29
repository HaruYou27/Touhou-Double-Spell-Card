extends Resource
class_name saveData

#Controls
enum input {KEYBOARD, MOUSE, TOUCH}

var auto_shoot := true
var input_method = input.KEYBOARD
var death_timer :float = 1.0
var hi_score := {}
var physics_speed := 1.0
var init_bomb := 3
var point_value := 1
var graze_value := 7

func change_difficulty() -> void:
	pass

func save():
	ResourceSaver.save('user://save.res', self)
