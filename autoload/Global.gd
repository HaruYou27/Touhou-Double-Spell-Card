extends Node2D

const playground := Vector2(646, 904)
var save : save_data

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.gd").new()
		save.new_save()
