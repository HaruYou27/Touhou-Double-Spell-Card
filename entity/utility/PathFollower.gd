extends PathFollow2D

@export var duration := 0.

@onready var tween := create_tween()

func _ready():
	tween.tween_property(self, 'progress_ratio', 1.0, duration)
	if loop:
		tween.set_loops()
	connect("child_exiting_tree",Callable(self,'call_deferred').bind('_child_exited_tree'))

func _child_exited_tree():
	if not get_child_count():
		queue_free()
