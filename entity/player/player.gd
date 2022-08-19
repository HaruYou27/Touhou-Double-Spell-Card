extends Node2D
class_name Player

var cooldown := 0

export (int) var speed := 527
export (int) var firerate
export (int) var firerate_focus
export (Array) var barrels

onready var bullet :Node = $bullet

func _ready() -> void:
	var index := 0
	for barrel in barrels:
		barrels[index] = get_node(barrel)
		index += 1
		
	firerate = (60 - firerate) / firerate
	firerate_focus = (60 - firerate_focus) / firerate_focus
	
	if Global.save.input_method == save_data.input.KEYBOARD:
		add_child(preload("res://autoload/controls/keyboard.gd").new())

#Input handler.
func _physics_process(delta:float) -> void:
	if cooldown:
		cooldown -= 1
	elif Global.save.auto_shoot or Input.is_action_pressed("shoot"):
		if Input.is_action_pressed("focus"):
			cooldown = firerate_focus
		else:
			cooldown = firerate
			bullet.Shoot(barrels)
