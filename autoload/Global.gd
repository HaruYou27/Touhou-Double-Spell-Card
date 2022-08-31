extends Node2D

signal graze
signal collect
signal bomb

const playground := Vector2(646, 904)

var save : saveData
var player

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.gd").new()
		save.save()
		
