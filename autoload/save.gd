extends Resource
class_name save_data

#Controls
enum input {KEYBOARD, MOUSE, TOUCH}
enum shoot {HOLD, TOGGLE, AUTO}

var hold_focus := true

func new_save():
	ResourceSaver.save('user://save.res', self)
