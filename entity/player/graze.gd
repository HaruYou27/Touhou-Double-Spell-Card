extends Area2D
class_name Graze
#Area to interact with world.

export (float) var graze_multipler = 1

onready var parent = $"."

func _hit(_data, _velocity) -> bool:

	parent.hitbox.mana += graze_multipler
	return false

func _on_graze_area_entered(area):
	pass
