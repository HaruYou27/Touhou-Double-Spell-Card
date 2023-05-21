extends Control
##Node that controls the current_event.

##Next level scene path.
@export var id := 0
@onready var user_data :UserData = Global.user_data

@export var root_node : Node2D
func _ready() -> void:
	VisualEffect.fade2black(true)
	VisualEffect.current_scene = root_node

@export var first_event : Node
func sync_start() -> void:
	rpc('game_started', Time.get_ticks_msec())
	var timer := get_tree().create_timer(3., true, true, true)
	timer.timeout.connect(first_event.start_event())
	
@rpc("reliable")
func game_started(host_time:int) -> void:
	var offset := (Global.get_host_time() - host_time) / 1000.
	var timer := get_tree().create_timer(3. - offset, true, true, true)
	timer.timeout.connect(first_event.start_event())

##Level finisher.
func finished() -> void:
	if Engine.is_editor_hint:
		return
	
	Global.change_scene(global.main_menu)
