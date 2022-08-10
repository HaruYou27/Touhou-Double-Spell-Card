extends Object
class_name input_handler

var is_focus : bool
var player : Node2D

func _init(node:Node2D) -> void:
	player = node

func move(delta:float) -> void:
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return
	var velocity := Vector2(x, y).normalized()
	
	if Input.is_action_pressed("focus"):
		velocity /= 2
		is_focus = true
	else:
		is_focus = false
		
	player.global_position += velocity * delta * Global.speed
	
