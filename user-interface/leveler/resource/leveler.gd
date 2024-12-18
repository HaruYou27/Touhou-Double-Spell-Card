extends Control
class_name Leveler

@onready var pause: Button = $pause
@onready var hud: HUD = $hud
@export var animator: AnimationPlayer
func _ready() -> void:
	tree.paused = false
	ScreenEffect.fade2black(true)
	Global.leveler = self
	rpc('start')
	animator.animation_finished.connect(hud.save_score)

@rpc("reliable", "any_peer", "call_local")
func start() -> void:
	if is_multiplayer_authority():
		rpc('_sync_start', Time.get_ticks_msec())
		#var timer := get_tree().create_timer(2., true, true, true)
		#timer.timeout.connect(animator.play.bind("game"))
		animator.play("game")
	
@rpc("reliable", "authority", "call_remote")
func _sync_start(host_time:int) -> void:
	animator.play("game")
	#var offset := (Global.get_host_time() - host_time) / 1000000.
	#var timer := get_tree().create_timer(2. - offset, true, true, true)
	#timer.timeout.connect(animator.play.bind("game"))

func revive_player() -> void:
	Global.player1.revive()
	
@onready var tree := get_tree()
func restart() -> void:
	tree.paused = true
	var tween : Tween = ScreenEffect.fade2black()
	tween.finished.connect(LevelLoader.load_scene.call_deferred.bind('', true))
