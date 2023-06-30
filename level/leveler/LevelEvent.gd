extends Node2D
class_name LevelEvent

@export var paths : Array[NodePath]

var nodes := []
func _ready() -> void:
	for path in paths:
		nodes.append(get_node(path))

func start_event() -> void:
	for node in nodes:
		node.start()

func _on_level_timer_timeout() -> void:
	ItemManager.ConvertBullet()
	queue_free()
