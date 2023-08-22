extends Control
class_name Leveler

@onready var user_data :UserData = Global.user_data

@onready var screen_effect := $ScreenEffect
func _ready() -> void:
	tree.paused = false
	screen_effect.fade2black(true)
	Global.leveler = self
	rpc('start')

@rpc("reliable", "any_peer", "call_local")
func start() -> void:
	if is_multiplayer_authority():
		rpc('_sync_start', Time.get_ticks_msec())
		var timer := get_tree().create_timer(2., true, true, true)
		timer.timeout.connect(animator.play.bind("game"))
	
@export var animator : AnimationPlayer
@rpc("reliable")
func _sync_start(host_time:int) -> void:
	var offset := (Global.get_host_time() - host_time) / 1000000.
	var timer := get_tree().create_timer(2. - offset, true, true, true)
	timer.timeout.connect(animator.play.bind("game"))

func _revive_player() -> void:
	Global.player1.revive()

func _finished() -> void:
	LevelLoader.load_scene(global.main_menu)

@onready var tree := get_tree()
func restart() -> void:
	tree.paused = true
	var tween : Tween = screen_effect.fade2black()
	tween.finished.connect(LevelLoader.restart_level)
