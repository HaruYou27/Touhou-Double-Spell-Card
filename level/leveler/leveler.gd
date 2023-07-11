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
		first_event.start_event()
	Global.set_process_unhandled_input(true)

@export var first_event : Node
func sync_start() -> void:
	rpc('game_started', Time.get_ticks_msec())
	var timer := get_tree().create_timer(3., true, true, true)
	timer.timeout.connect(first_event.start_event)
	
@rpc("reliable")
func game_started(host_time:int) -> void:
	var offset := (Global.get_host_time() - host_time) / 1000.
	var timer := get_tree().create_timer(3. - offset, true, true, true)
	timer.timeout.connect(first_event.start_event)
