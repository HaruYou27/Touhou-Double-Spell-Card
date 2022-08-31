class_name Enemy
extends Area2D
#Base class for common enemy (Not boss).

export (int) var hp

func _hit() -> void:
	hp -= 1
