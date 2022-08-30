extends Node2D

signal graze
signal collect
signal bomb
signal collect_bullet

const playground := Vector2(646, 904)
const point_value := 1
const graze_value := 10
const bullet_value := 1

var save : saveData
var player : Player

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.gd").new()
		save.save()
