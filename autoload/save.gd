extends Resource
class_name saveData

#Controls
enum input {KEYBOARD, MOUSE, TOUCH}
enum difficulty {EASY, NORMAL, HARD}

var auto_shoot := true
var input_method = input.KEYBOARD
var death_timer :float = 1.0
var init_bomb := 3
var hi_score := {}

func save():
	ResourceSaver.save('user://save.res', self)
