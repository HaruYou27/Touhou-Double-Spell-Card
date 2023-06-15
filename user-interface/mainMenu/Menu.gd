extends Control

const ani_duration = .25

@onready var current_menu := $main
var next_menu :Control
func change_menu(id:StringName):
	next_menu = get_node(NodePath(id))
	next_menu.show()
	
	var tween := create_tween()
	tween.tween_property(current_menu, 'modulate', Color.TRANSPARENT, ani_duration)
	tween.tween_property(next_menu, 'modulate', Color.WHITE, ani_duration)
	tween.finished.connect(_change_finished)
	
func _change_finished():
	current_menu.hide()
	current_menu = next_menu
