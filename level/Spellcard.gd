extends Node2D

@export var nodes2start : Array[NodePath]
var nodes := []
func _ready() -> void:
	for path in nodes2start:
		nodes.append(get_node(path))

@export var start := false :
	set(value):
		if value:
			Global.revive_player.emit()
			for node in nodes:
				node.start()
@export var delete := false :
	set(value):
		if value:
			queue_free()
