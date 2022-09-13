extends ColorRect

onready var tree := get_tree()
onready var resume :AnimatedTextButton = $VBoxContainer/Resume
onready var stage :PackedScene = get_parent().stage_scene

onready var color_def = color
var color_trans

func _ready() -> void:
	VisualServer.canvas_item_set_z_index(get_canvas_item(), 4000)
	color_def.a = .69
	color.a = 0.0
	color_trans = color
	show()

func _on_Resume_pressed() -> void:
	var tween := create_tween()
	if tree.paused:
		tween.tween_property(self, 'color', color_trans, .15)
		tween.connect("finished", tree, 'set_pause', [false])
	else:
		tree.paused = true
		tween.tween_property(self, 'color', color_def, .15)
		resume.grab_focus()

func _on_Quit_pressed():
	tree.change_scene("res://user-interface/mainMenu/Menu.scn")
