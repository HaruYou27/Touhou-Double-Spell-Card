extends Control

@export var select_level : Control
@export var setting : Control

var animating := false

func _on_animation_finished() -> void:
	animating = false

func _on_setting_pressed() -> void:
	if animating:
		return
	
	animating = true
	setting.show()
	setting.modulate = Color.TRANSPARENT
	var tween := create_tween()
	tween.tween_property(select_level, 'modulate', Color.TRANSPARENT, .25)
	tween.tween_property(setting, 'modulate', Color.WHITE, .25)
	tween.finished.connect(select_level.hide)
	tween.finished.connect(_on_animation_finished)
