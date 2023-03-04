extends Node

const ani_length := .5

@onready var settings := $setting
@onready var level := $level
@onready var main := $main
@onready var camera := $Camera2D

func _ready() -> void:
	settings.hide()
	level.hide()

func _on_settings_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(camera, 'position', settings.position, ani_length)
	tween.finished.connect(Callable(main, 'hide'))
	settings.show()

func _on_back_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(camera, 'position', main.position, ani_length)
	tween.finished.connect(Callable(settings, 'hide'))
	tween.finished.connect(Callable(level, 'hide'))
	main.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(camera, 'position', level.position, ani_length)
	tween.finished.connect(Callable(main, 'hide'))
	level.show()
