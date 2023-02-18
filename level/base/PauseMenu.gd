extends ColorRect

onready var tree := get_tree()
onready var resume :Button = $VBoxContainer/Resume

func _input(event):
	if event.is_action_pressed("pause"):
		tree.paused = true
		show()
		create_tween().tween_property(self, 'modulate', Color.white, .15)
		resume.call_deferred('set_disabled', false)
		set_process_input(false)
		accept_event()

func _ready():
	VisualServer.canvas_item_set_z_index(get_canvas_item(), 4000)

func _on_Resume_pressed():
	resume.disabled = true
	tree.paused = false
	var tween := create_tween()
	tween.tween_property(self, 'modulate', Color.transparent, .15)
	tween.connect("finished", self, 'hide')
	set_process_input(true)
