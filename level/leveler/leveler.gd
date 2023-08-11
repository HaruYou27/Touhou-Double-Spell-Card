extends Control

@onready var user_data :UserData = Global.user_data

@export var player_container : Node2D
func _ready() -> void:
	VisualEffect.fade2black(true)
	if Global.player1:
		player_container.add_child(Global.player1)
	if Global.player2:
		player_container.add_child(Global.player2)
		if is_multiplayer_authority():
			sync_start()
	else:
		animator.play("game")
	Global.set_process_unhandled_input(true)

@export var animator : AnimationPlayer
@export var bgm : AudioStreamPlayer
func sync_start() -> void:
	rpc('game_started', Time.get_ticks_msec())
	var timer := get_tree().create_timer(2., true, true, true)
	timer.timeout.connect(animator.play.bind("game"))
	
@rpc("reliable")
func game_started(host_time:int) -> void:
	var offset := (Global.get_host_time() - host_time) / 1000.
	var timer := get_tree().create_timer(2. - offset, true, true, true)
	timer.timeout.connect(animator.play.bind("game"))
	timer.timeout.connect(animator.play.bind(AudioServer.get_output_latency() + AudioServer.get_time_to_next_mix()))

func _revive_player() -> void:
	Global.player1.revive()

func _finished() -> void:
	Global.change_scene(global.main_menu)
	
# Avoid crash when reload scene
func _exit_tree() -> void:
	ItemManager.clear()
	Global.player1 = load(Global.player1.scene_file_path).instantiate()
	if Global.player2:
		Global.player2 = load(Global.player2.scene_file_path).instantiate()
