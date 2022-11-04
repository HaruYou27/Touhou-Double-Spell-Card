extends ColorRect

onready var tree := get_tree()
onready var resume :AnimatedTextButton = $VBoxContainer/Resume

func _input(event):
	if event.is_action_pressed("pause"):
		tree.paused = true
		show()
		create_tween().tween_property(self, 'modulate', Color.white, .15)
		resume.grab_focus()
		set_process_input(false)
		accept_event()

func _ready() -> void:
	VisualServer.canvas_item_set_z_index(get_canvas_item(), 4000)
	$VBoxContainer/Restart.connect("pressed", Rewind, 'rewind')

func _on_Resume_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(self, 'modulate', Color.transparent, .15)
	tween.connect("finished", self, '_resume')
	set_process_input(true)

func _resume():
	tree.paused = false
	hide()
