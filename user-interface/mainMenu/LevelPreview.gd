extends Node2D
class_name LevelPreview

@export var title := 'Cool name or sth'
@export var foreground : Node2D
@export var bgm : AudioStreamPlayer
@export var start_pos := 0.
@export_file var level_scene

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	
func _on_visibility_changed():
	foreground.visible = visible
	if visible:
		foreground.modulate = Color.WHITE

func hide_foreground() -> void:
	if not foreground.visible:
		return
	
	foreground.modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(foreground, 'modulate', Color.TRANSPARENT, .25)
	tween.finished.connect(foreground.hide)
	
func show_foreground() -> void:
	if foreground.visible:
		return
	
	foreground.show()
	foreground.modulate = Color.TRANSPARENT
	var tween := create_tween()
	tween.tween_property(foreground, 'modulate', Color.WHITE, .25)
	tween.finished.connect(bgm.play.bind(start_pos))
