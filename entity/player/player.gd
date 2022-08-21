extends Node2D
class_name Player

var cooldown := 0

export (int) var speed := 527

func _ready() -> void:
	if Global.save.input_method == save_data.input.KEYBOARD:
		add_child(preload("res://autoload/controls/keyboard.gd").new())
