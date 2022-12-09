extends Control

signal select_level

onready var tree := get_tree()
onready var fade := ColorRect.new()

onready var conti :Button = $main/continue
onready var start :Button = $main/start

const ani_time := .15

func _ready():
	if Global.config.first_time:
		start.grab_focus()
		return
		
	conti.grab_focus()

func fade2black(level):
	fade.color = Global.fade_trans
	add_child(fade)
	var tween := create_tween()
	tween.tween_method(AudioServer, 'set_bus_volume_db', AudioServer.get_bus_volume_db(1), -80, Global.fade_time)
	tween.parallel().tween_property(fade, 'color', Global.fade_black, Global.fade_time)
	tween.connect("finished", tree, 'change_scene_to', [level])

func _on_start_pressed():
	if Global.config.first_character:
		pass
	
func _on_continue_pressed():
	fade2black(load(Global.config.level))

func _on_help_pressed():
	var tutorial
	fade2black(tutorial)

func _on_quit_pressed():
	tree.quit()
