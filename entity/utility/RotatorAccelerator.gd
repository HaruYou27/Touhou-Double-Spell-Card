extends Rotator
class_name RotatorAccelerator
## Should only be use on bosses.

@export var speed_final := -TAU
@export var duration := 5.727
@export var ease_type : Tween.EaseType = Tween.EASE_IN

func _ready() -> void:
	if not is_multiplayer_authority():
		return
	var tween := create_tween()
	tween.set_ease(ease_type)
	tween.tween_property(self, 'speed', speed_final, duration)
