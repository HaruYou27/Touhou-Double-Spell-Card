extends Object
class_name input_handler

static func move(delta:float, position:Vector2) -> Vector2:
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return position
	var velocity := Vector2(x, y).normalized()
	
	if Input.is_action_pressed("focus"):
		velocity /= 2
	
	return position + velocity * delta * Global.speed
