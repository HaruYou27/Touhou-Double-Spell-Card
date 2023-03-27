extends Control

const ani_length := .25

var sub_menus : Array
@onready var current_menu := $main

func _ready():
	var nodes := get_children()
	nodes.remove_at(0)
	
	for node in nodes:
		if node is Control:
			sub_menus.append(node)
			node.hide()
			node.modulate = Color.TRANSPARENT
	
	current_menu.show()
	current_menu.modulate = Color.WHITE

func _on_quit_pressed() -> void:
	get_tree().quit()

func _switch_menu(index:int) -> void:
	var tween := create_tween()
	tween.tween_property(current_menu, 'modulate', Color.TRANSPARENT, ani_length)
	tween.finished.connect(Callable(current_menu, 'hide'))
	current_menu = sub_menus[index]
	
	current_menu.show()
	tween.tween_property(current_menu, 'modulate', Color.WHITE, ani_length)

func _on_level_character(level:LevelHeader):
	_switch_menu(3)
	sub_menus[3].header = level
