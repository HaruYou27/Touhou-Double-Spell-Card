extends ColorRect

onready var tree := get_tree()
onready var playground = get_parent()

func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("pause"):
		tree.paused = false
		playground.remove_child(self)

func _on_Resume_pressed() -> void:
	tree.paused = false
	playground.remove_child(self)
