extends Area2D

signal died

@export var hp := 1
@onready var point = hp

func _hit() -> void:
	hp -= 1
	if not hp:
		die()
		
@onready var explosion := $explosion
func die() -> void:
	ItemManager.SpawnItem(point, global_position)
	VisualEffect.death_vfx(global_position)
	explosion.explode()
	died.emit()
