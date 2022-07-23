extends Reference
#Script handles player inputs.

var parent
var focus :bool

func move():
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return
	
	if Input.is_action_pressed("focus"):
		focus = true
		return Vector2(x, y).normalized() / 2
	else:
		return Vector2(x, y).normalized()
