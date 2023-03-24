extends Node

signal next_event

func _ready() -> void:
	call_deferred('start_event')

func start_event() -> void:
	var boss :Node2D = $"../level/SpaceRelaxed/yukari"
	
	var tween := create_tween()
	tween.tween_property(boss, 'position', Vector2(302, 186), .5)
	tween.finished.connect(Callable(self, 'emit_signal').bind('next_event'))
