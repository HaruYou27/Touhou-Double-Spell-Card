extends Node

onready var tree := get_tree()
onready var fade :ColorRect = $fade
onready var bgm :AudioStreamPlayer = $Bgm
onready var camera :Camera2D = $Camera2D

onready var main :Button = $main/Button/start
onready var settings :Button = $setting/TabContainer/Graphic/fullscreen

const black := Color(.09, .09, .09, 1)
const fade_time := 1.0
const muted := -80

func _ready():
	remove_child(fade)
	main.grab_focus()

func _on_help_pressed():
	add_child(fade)
	fade.rect_position = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(fade, 'color', black, fade_time)
	tween.parallel().tween_property(bgm, 'volume_db', muted, fade_time)
	tween.connect("finished", tree, 'change_scene')
	
func _on_settings_pressed():
	create_tween().tween_property(camera, 'position', Vector2(-1280, 0), .25)
	settings.grab_focus()

func _on_credits_pressed():
	create_tween().tween_property(camera, 'position', Vector2(1280, 0), .25)

func _on_quit_pressed():
	tree.quit()

func _on_back_pressed():
	create_tween().tween_property(camera, 'position', Vector2.ZERO, .25)
	main.grab_focus()

func _on_start_pressed():
	pass # Replace with function body.

func _on_continue_pressed():
	add_child(fade)
	fade.rect_position = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(fade, 'color', black, fade_time)
	tween.parallel().tween_property(bgm, 'volume_db', muted, fade_time)
	tween.connect("finished", tree, 'change_scene')
