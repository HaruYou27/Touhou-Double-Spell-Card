extends Resource
class_name save_data

#Controls
enum input {KEYBOARD, MOUSE, TOUCH}

var auto_shoot := true

func new_save():
	ResourceSaver.save('user://save.res', self)
