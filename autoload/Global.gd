extends Node2D

signal graze
signal bomb
signal collect
signal shake(duration)
signal freeze

var save : saveData
var player setget _set_player
var boss

func _set_player(value:Node2D) -> void:
	player = value
	BulletFx.target = value
	GrazeFx.target = value

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.gd").new()
		save.save()
	randomize()
