extends Node2D

signal graze
signal bomb
signal collect
signal shake(duration)
signal freeze

var save_data : saveData
var player setget _set_player
var boss

func _set_player(value:Node2D) -> void:
	player = value
	BulletFx.target = value
	GrazeFx.target = value
	ItemManager.target = value

func _ready() -> void:
	save_data = load('user://save.res')
	if not save_data:
		save_data = preload("res://autoload/save.gd").new()
		save_data.new_save()
	randomize()
