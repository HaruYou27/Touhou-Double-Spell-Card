extends Node2D

signal graze
signal collect

const playground := Vector2(646, 904)

var save : saveData
var player : Player
var physic_speed := 1.0

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.gd").new()
		save.save()
	physic_speed = save.physic_speed
