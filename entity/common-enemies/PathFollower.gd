extends PathFollow2D
class_name PathFollower

export (float) var time
export (NodePath) var visual_node

func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, 'unit_offset', 1.0, time)
	tween.connect("finished", get_node(visual_node), 'queue_free')
	if loop:
		tween.set_loops()
