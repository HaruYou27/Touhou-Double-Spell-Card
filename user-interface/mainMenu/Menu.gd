extends Node

onready var tree := get_tree()
onready var fade :ColorRect = $fade
onready var bgm :AudioStreamPlayer = $Bgm
onready var camera :Camera2D = $Camera2D

const black := Color(.09, .09, .09, 1)
const fade_time := 1.0
const muted := -80

func _ready():
	remove_child(fade)

func _on_New_pressed():
	create_tween().tween_property(camera, 'position', Vector2(0, -960), .25)

func _on_Continue_pressed():
	add_child(fade)
	fade.rect_position = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(fade, 'color', black, fade_time)
	tween.parallel().tween_property(bgm, 'volume_db', muted, fade_time)
	tween.connect("finished", tree, 'change_scene')

func _on_Help_pressed():
	add_child(fade)
	fade.rect_position = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(fade, 'color', black, fade_time)
	tween.parallel().tween_property(bgm, 'volume_db', muted, fade_time)
	tween.connect("finished", tree, 'change_scene')
	
func _on_Options_pressed():
	create_tween().tween_property(camera, 'position', Vector2(-1280, 0), .25)

func _on_Credits_pressed():
	create_tween().tween_property(camera, 'position', Vector2(1280, 0), .25)
	

func _on_Quit_pressed():
	tree.quit()

func _on_back_pressed():
	create_tween().tween_property(camera, 'position', Vector2.ZERO, .25)
