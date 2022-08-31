extends Node2D

signal graze
signal bomb
signal collect

var save : saveData
var player

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.gd").new()
		save.save()
		
