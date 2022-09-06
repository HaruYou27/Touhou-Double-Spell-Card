extends Node

onready var tree := get_tree()
onready var fade :ColorRect = $fade
onready var bgm :AudioStreamPlayer = $Bgm
onready var camera :Camera2D = $Camera2D

onready var main :Control = $main
onready var option :Control = $Options

func _ready():
	remove_child(fade)

func _on_New_pressed():
	create_tween().tween_property(camera, 'position', Vector2(0, -960), .25)

func _on_Continue_pressed():
	add_child(fade)
	fade.rect_position = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(fade, 'color', Color(.09, .09, .09, 1), 1.0)
	tween.parallel().tween_property(bgm, 'volume_db', 0, 1.0)
	tween.connect("finished", tree, 'change_scene')

func _on_Help_pressed():
	add_child(fade)
	fade.rect_position = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(fade, 'color', Color(.09, .09, .09, 1), 1.0)
	tween.parallel().tween_property(bgm, 'volume_db', 0, 1.0)
	tween.connect("finished", tree, 'change_scene')
	
func _on_Options_pressed():
	create_tween().tween_property(camera, 'position', Vector2(-1280, 0), .25)
	option.set_process_unhandled_input(true)

func _on_Credits_pressed():
	create_tween().tween_property(camera, 'position', Vector2(1280, 0), .25)

func _on_Quit_pressed():
	tree.quit()

func _on_back_pressed():
	create_tween().tween_property(camera, 'position', Vector2.ZERO, .25)
