extends PathFollow2D
class_name  PathFollower2D

@export var time := 0.
@export var ease_type : Tween.EaseType = Tween.EASE_OUT_IN
var reverse := false

@export var enemy: Enemy
@onready var tween: Tween

func die() -> void:
	if tween:
		tween.kill()
	set_process(false)
	progress_ratio = float(reverse)


func _ready() -> void:
	enemy.died.connect(die)
	cubic_interp = false
	rotates = false
	set_process(false)

func start() -> void:
	if not is_multiplayer_authority():
		return
	enemy.reset.call_deferred()
	progress_ratio = float(reverse)

	tween = create_tween()
	tween.set_ease(ease_type)
	tween.tween_property(self, 'progress_ratio', float(not reverse), time)
	tween.tween_callback(enemy.timeout)
	
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		return
	set_process(true)
