extends Resource
class_name save_data

#Controls
enum input {KEYBOARD, MOUSE, TOUCH}

var auto_shoot := true
var input_method = input.KEYBOARD
var death_timer :float = 1.0

func new_save():
	ResourceSaver.save('user://save.res', self)
