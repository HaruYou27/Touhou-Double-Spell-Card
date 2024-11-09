extends Area2D
class_name Enemy

signal died

@export var hp := 1
@onready var point = hp
var is_dead := false
func _hit() -> void:
	hp -= 1
	if not hp:
		die()
		
@onready var explosion := $explosion
@onready var death_sfx := $sfx
@onready var visual := $visual
var layer := 0
func _ready() -> void:
	layer = collision_layer
	collision_layer = 0

func die() -> void:
	ItemManager.spawn_item(point, global_position)
	explosion.emitting = true
	death_sfx.play()
	died.emit()
	is_dead = true
	_timeout()

func reset() -> void:
	collision_layer = layer
	visual.show()
	hp = point
	is_dead = false

func _on_body_entered(body) -> void:
	if body is Player:
		body._hit()
	else:
		die()

func _timeout():
	visual.hide()
	collision_layer = 0
