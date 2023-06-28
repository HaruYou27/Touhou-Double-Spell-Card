extends PathFollow2D
class_name  PathFollower2D

@export var time := 0.
@export var reverse := false

@onready var tween := create_tween()
func  _ready() -> void:
	if reverse:
		progress_ratio = 1.
		tween.tween_property(self, 'progress_ratio', 0., time)
	else:
		progress_ratio = 0.
		tween.tween_property(self, 'progress_ratio', 1., time)
	
	tween.tween_callback(queue_free)
