extends Control

const ani_length := .15

onready var settings := $setting
onready var level := $level
onready var main := $main
onready var camera := $Camera2D

func _ready():
	settings.hide()
	level.hide()

func _on_settings_pressed():
	var tween := create_tween()
	tween.tween_property(camera, 'position', Vector2(-1920, 0), ani_length)
	tween.connect("finished", main, 'hide')
	settings.show()

func _on_back_pressed():
	var tween := create_tween()
	tween.tween_property(camera, 'position', Vector2.ZERO, ani_length)
	tween.connect("finished", settings, 'hide')
	tween.connect("finished", level, 'hide')
	main.show()

func select_level():
	var tween := create_tween()
	tween.tween_property(camera, 'position', Vector2(1920, 0), ani_length)
	tween.connect("finished", main, 'hide')
	level.show()
