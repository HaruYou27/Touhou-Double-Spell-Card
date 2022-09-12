extends Control

signal select_level

onready var tree := get_tree()
onready var fade :ColorRect = $fade
onready var black := fade.color

onready var title :Label = $title
onready var project_name := title.text

onready var main_menu :VBoxContainer = $main
onready var char_menu :Control = $character

const fade_time := 1.0
const ani_time := .15

func _ready():
	black.a = 1.0
	remove_child(fade)

func fade2black(level):
	add_child(fade)
	var tween := create_tween()
	tween.tween_method(AudioServer, 'set_bus_volume_db', AudioServer.get_bus_volume_db(1), -80, fade_time)
	tween.parallel().tween_property(fade, 'color', black, fade_time)
	tween.connect("finished", tree, 'change_scene_to', [level])

func _on_start_pressed():
	if Global.save_data.hi_score.empty():
		pass
	elif Global.save_data.characters == 1:
		emit_signal("select_level")
	
	var tween := create_tween()
	tween.tween_property(title, 'text', 'Select Character', ani_time)
	tween.parallel().tween_property(char_menu, 'modulate', Color.white, ani_time)

func _on_continue_pressed():
	fade2black(load(Global.save_data.level))

func _on_help_pressed():
	var tutorial
	fade2black(tutorial)

func _on_quit_pressed():
	tree.quit()
