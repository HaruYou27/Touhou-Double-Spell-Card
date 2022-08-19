extends Node

onready var parent :Node2D = get_parent()

func _physics_process(delta:float) -> void:
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	if not x and not y:
		return
	var velocity := Vector2(x, y).normalized()
	
	if Input.is_action_pressed("focus"):
		velocity /= 2
	
	parent.global_position += velocity * delta * parent.speed
	parent.global_position = parent.global_position.posmodv(Global.playground)
