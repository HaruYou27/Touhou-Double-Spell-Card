extends Resource
class_name save_data

#Controls
enum input {KEYBOARD, MOUSE, TOUCH}

var auto_shoot : bool

func new_save():
	ResourceSaver.save('user://save.res', self)
