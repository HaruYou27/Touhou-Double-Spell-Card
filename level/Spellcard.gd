extends Node2D

@export var nodes2start : Array[NodePath]
var nodes := []
func _ready() -> void:
	for path in nodes2start:
		nodes.append(get_node(path))

func _start() -> void:
	Global.revive_player.emit()
	show()
	for node in nodes:
		node.start()
