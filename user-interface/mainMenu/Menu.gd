extends Control

const ani_length := .15

onready var settings := $setting
onready var levels := $level
onready var main := $main
onready var camera := $Camera2D

func _on_settings_pressed():
	var tween := create_tween()
	tween.ween_property(camera, 'position', Vector2(-1280, 0), ani_length)
	tween.connect("finished", main, 'hide')

func _on_back_pressed():
	var tween := create_tween()
	tween.tween_property(camera, 'position', Vector2.ZERO, ani_length)
	tween.connect("finished", settings, 'hide')
	tween.connect("finished", levels, 'hide')

func select_level():
	var tween := create_tween()
	tween.tween_property(camera, 'position', Vector2(2560, 0), ani_length)
	tween.connect("finished", main, 'hide')
