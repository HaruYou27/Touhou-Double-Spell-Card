extends PathFollow2D
class_name  PathFollower2D

signal died

@export var time := 0.
var reverse := false

@onready var enemy := $Enemy
@onready var tween : Tween
func start() -> void:
	enemy.reset()
	tween = create_tween()
	progress_ratio = reverse
	tween.tween_property(self, 'progress_ratio', float(not reverse), time)
	tween.tween_callback(emit_signal.bind("died"))

func _on_enemy_died() -> void:
	died.emit()
	if tween:
		tween.kill()
