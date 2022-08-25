extends StaticBody2D

onready var parent : Player = get_parent()

func _collect(value:int) -> void:
	parent.emit_signal("update_score", value)

func _hit() -> void:
	parent.emit_signal("update_score", 1)
