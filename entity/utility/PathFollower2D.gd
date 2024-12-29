extends PathFollow2D
class_name  PathFollower2D

@export var time := 0.
var reverse := false

@export var enemy: Enemy
@onready var tween: Tween

func die() -> void:
	if tween:
		tween.kill()
	set_process(false)
	progress_ratio = 0.0

func _ready() -> void:
	enemy.died.connect(die)
	set_process(false)

func start() -> void:
	if not is_multiplayer_authority():
		return
	
	rpc("sync_start")
	sync_start()
	
	tween = create_tween()
	set_process(true)
	tween.tween_property(self, 'progress_ratio', float(not reverse), time)
	tween.tween_callback(enemy.timeout)
	
var tick := false
func _process(_delta: float) -> void:
	tick = not tick
	if tick:
		return
	rpc("_sync_position", progress_ratio)
	
@rpc("authority","unreliable_ordered","call_remote")
func _sync_position(pos:float) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, 'progress_ratio', pos, 0.05)

@rpc("reliable", "authority", "call_remote")
func sync_start() -> void:
	enemy.reset.call_deferred()
	progress_ratio = float(reverse)
