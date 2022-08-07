extends Node

var save

onready var viewport := get_viewport()
onready var tree := get_tree()
onready var tween :Tween = $Tween

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.res")
		save.new_save()
