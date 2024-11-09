extends Area2D

@onready var tree := get_tree()
var targets: Array[Node2D] = []
func _on_area_entered(area: Area2D) -> void:
	targets.append(area)
