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
	Global.item_manager.spawn_item(point, global_position)
	explosion.emitting = true
	death_sfx.play()
	death_timer.start()
	visual.hide()

func _on_timer_timeout() -> void:
	died.emit()
	process_mode = Node.PROCESS_MODE_DISABLED

func reset() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	visual.show()
	hp = point

func _on_body_entered(body) -> void:
	if body is Player:
		body._hit()
	else:
		die()
