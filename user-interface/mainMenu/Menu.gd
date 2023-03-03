extends Node

const ani_length := .5

@onready var settings := $setting
@onready var level := $level
@onready var main := $main
@onready var camera := $Camera2D

func _ready():
	settings.hide()
	level.hide()

func _on_settings_pressed():
	var tween := create_tween()
	tween.tween_property(camera, 'position', settings.position, ani_length)
	tween.connect("finished",Callable(main,'hide'))
	settings.show()

func _on_back_pressed():
	var tween := create_tween()
	tween.tween_property(camera, 'position', main.position, ani_length)
	tween.connect("finished",Callable(settings,'hide'))
	tween.connect("finished",Callable(level,'hide'))
	main.show()

func _on_quit_pressed():
	get_tree().quit()

func _on_start_pressed():
	var tween := create_tween()
	tween.tween_property(camera, 'position', level.position, ani_length)
	tween.connect("finished",Callable(main,'hide'))
	level.show()
