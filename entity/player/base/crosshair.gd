@tool
extends Node2D

@export var displacement = 16 : set = _set_displacement
func _set_displacement(value:int) -> void:
	displacement = value
	var angle = 0
	var offset = Vector2(value, 0)
	for child in get_children():
		if child is Node2D:
			child.rotation = angle
			child.position = offset.rotated(angle)
			
			angle += PI/4
