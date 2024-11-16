extends PathFollow2D
class_name  PathFollower2D

signal timeout

@export var time := 0.
var reverse := false

@onready var enemy: Enemy = $Enemy
@onready var tween: Tween
func start() -> void:
	if not is_multiplayer_authority():
		return
	
	rpc("_sync_start")
	enemy.reset()
	tween = create_tween()
	progress_ratio = reverse
	tween.tween_property(self, 'progress_ratio', float(not reverse), time)
	tween.tween_callback(enemy.emit_signal.bind("timeout"))
	
func _process(delta: float) -> void:
	rpc("_sync_position", progress_ratio)
	
@rpc("authority","unreliable_ordered","call_remote")
func _sync_position(pos:float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, 'progress_ratio', pos, 0.03)

@rpc("reliable", "authority", "call_remote")
func _sync_start() -> void:
	enemy.reset()
	progress_ratio = reverse

func _on_enemy_timeout() -> void:
	timeout.emit()
	if tween:
		tween.kill()
