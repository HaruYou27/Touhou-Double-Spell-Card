extends Node2D

const playground := Vector2(646, 904)

var player_damage :int = 1
var save : saveData
var player : Player

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.gd").new()
		save.save()
