extends Area2D

signal died

@export var hp := 1
@onready var point = hp
func _hit() -> void:
	hp -= 1
	if not hp:
		die()
		
@onready var explosion := $explosion
@onready var death_sfx := $explosion/sfx
@onready var death_timer := $explosion/Timer
func die() -> void:
	ItemManager.SpawnItem(point, global_position)
	explosion.emitting = true
	death_sfx.play()
	death_timer.start()

func _on_timer_timeout():
	died.emit()
