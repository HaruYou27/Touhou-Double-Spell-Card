extends Rotator
class_name RotatorAccelerator
## Should only be use on bosses.

@export var speed_final := PI
@export var duration := 5.727
@export var ease_type : Tween.EaseType = Tween.EASE_IN

func _ready() -> void:
	var tween := create_tween()
	tween.set_ease(ease_type)
	tween.tween_property(self, 'speed', speed_final, duration)

func transform_barrel() -> void:
	return
	
