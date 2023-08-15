extends Control
class_name Leveler

@onready var user_data :UserData = Global.user_data

@onready var screen_effect := $ScreenEffect
func _ready() -> void:
	screen_effect.fade2black(true)
	Global.leveler = self
	var root := get_parent()
	if Global.player1:
		root.add_child.call_deferred(Global.player1)
	if Global.player2:
		root.add_child.call_deferred(Global.player2)
		if is_multiplayer_authority():
			sync_start()
	else:
		animator.play("game")
	Global.set_process_unhandled_input(true)

@export var animator : AnimationPlayer
func sync_start() -> void:
	rpc('game_started', Time.get_ticks_msec())
	var timer := get_tree().create_timer(2., true, true, true)
	timer.timeout.connect(animator.play.bind("game"))
	
@rpc("reliable")
func game_started(host_time:int) -> void:
	var offset := (Global.get_host_time() - host_time) / 1000000.
	var timer := get_tree().create_timer(2. - offset, true, true, true)
	timer.timeout.connect(animator.play.bind("game"))

func _revive_player() -> void:
	Global.player1.revive()

func _finished() -> void:
	LevelLoader.load_scene(global.main_menu)
	
@onready var tree := get_tree()
@rpc("any_peer", "call_local")
func restart() -> void:
	tree.call_group("Bullet Manager", "clear")
	Global.player1.restart()
