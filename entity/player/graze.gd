extends StaticBody2D

onready var parent : Player = get_parent()

func _collect(value:int) -> void:
	parent.emit_signal("collect", value)

func _hit() -> bool:
	parent.emit_signal("graze", 1)
	return true
