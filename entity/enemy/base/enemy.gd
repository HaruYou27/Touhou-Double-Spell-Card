extends Area2D
class_name Enemy

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
@onready var visual := $visual
func die() -> void:
	Global.ItemManager.SpawnItem(point, global_position)
	explosion.emitting = true
	death_sfx.play()
	death_timer.start()
	visual.hide()

func _on_timer_timeout() -> void:
	died.emit()
	monitorable = false

func reset() -> void:
	monitorable = true
	visual.show()
	hp = point
