extends Node2D

export (float) var speed = 500

var save : save_data

onready var viewport := get_viewport()
onready var tree := get_tree()
onready var tween :Tween = $Tween

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.gd").new()
		save.new_save()
