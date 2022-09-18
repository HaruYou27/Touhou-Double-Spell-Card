extends ColorRect

onready var tree := get_tree()
onready var resume :AnimatedTextButton = $VBoxContainer/Resume

onready var color_def = color
var color_trans

func _input(event):
	if event.is_action_pressed("pause"):
		tree.paused = true
		create_tween().tween_property(self, 'color', color_def, .15)
		resume.grab_focus()
		set_process_input(false)

func _ready() -> void:
	VisualServer.canvas_item_set_z_index(get_canvas_item(), 4000)
	color_def.a = .69
	color.a = 0.0
	color_trans = color

func _on_Resume_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(self, 'color', color_trans, .15)
	tween.connect("finished", tree, 'set_pause', [false])
	set_process_input(true)
