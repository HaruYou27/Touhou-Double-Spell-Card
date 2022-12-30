extends PathFollow2D

export (float) var duration

onready var tween := create_tween()

func _ready():
	tween.tween_property(self, 'unit_offset', 1.0, duration)
	if loop:
		tween.set_loops()
	connect("child_exiting_tree", self, 'call_deferred', ['_child_exited_tree'])

func _child_exited_tree():
	if not get_child_count():
		queue_free()
