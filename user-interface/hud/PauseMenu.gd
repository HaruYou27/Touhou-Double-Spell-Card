extends ColorRect

onready var tree := get_tree()
onready var content :VBoxContainer = $VBoxContainer

func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not tree.paused:
			tree.paused = true
			add_child(content)
			var tween := create_tween()
			tween.tween_property(self, 'color', Color(.13, .13, .13, .69), .15)
		elif tree.paused:
			_on_Resume_pressed()
		
func _ready() -> void:
	remove_child(content)
	VisualServer.canvas_item_set_z_index(get_canvas_item(), 4000)

func _on_Resume_pressed() -> void:
	var tween := create_tween()
	tween.tween_property(self, 'color', Color(.13, .13, .13, 0), .15)
	tween.connect("finished", self, 'remove_child', [content])
	tween.connect("finished", tree, 'set_pause', [true])
