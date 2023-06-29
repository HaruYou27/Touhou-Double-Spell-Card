extends PathFollow2D
class_name  PathFollower2D

signal died

@export var time := 0.
@export var reverse := false
@export var visual : Node2D

@onready var tween : Tween
func  _enter_tree() -> void:
	tween = create_tween()
	progress_ratio = reverse
	tween.tween_property(self, 'progress_ratio', not reverse, time)
	
	tween.tween_callback(emit_signal.bind("died"))

func _on_hitbox_died() -> void:
	visual.hide()
	tween.kill()
	died.emit()
