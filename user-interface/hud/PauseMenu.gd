extends ColorRect

onready var tree := get_tree()
onready var content :VBoxContainer = $VBoxContainer

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if not tree.paused:
			tree.paused = true
			visible = true
			add_child(content)
		elif tree.paused:
			_on_Resume_pressed()
		
func _ready() -> void:
	remove_child(content)
	VisualServer.canvas_item_set_z_index(get_canvas_item(), 4000)

func _on_Resume_pressed() -> void:
	tree.paused = false
	visible = false
	remove_child(content)
