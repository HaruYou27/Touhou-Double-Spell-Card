extends Node

onready var parent :Node2D = get_parent()

func _physics_process(delta:float) -> void:
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return
	var velocity := Vector2(x, y).normalized()
	
	if Input.is_action_pressed("focus"):
		velocity /= 4
		
	parent.position += velocity * delta * parent.speed
	parent.position.x = clamp(parent.position.x, 0.0, 646.0)
	parent.position.y = clamp(parent.position.y, 0.0, 904.0)
