extends Node

signal next_event

func _ready() -> void:
	call_deferred('start_event')

func start_event() -> void:
	var boss :Node2D = $yukari
	Global.player.bomb_count = 0
	Global.can_player_shoot.emit(false)
	
	var tween := create_tween()
	tween.tween_property(boss, 'global_position', Vector2(302, 186), .5)
	tween.finished.connect(Callable(self, 'emit_signal').bind('next_event'))
