extends Area2D
class_name Enemy

signal died

## Each bullet deal 1 damage.
@export var hp := 1
## Fair reward.
@onready var point = hp
## Don't free the node, marked it instead.
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
	collision_layer = 0
	ItemManager.spawn_item(point, global_position)
	explosion.emitting = true
	death_sfx.play()
	died.emit()
	timeout()

func reset() -> void:
	collision_layer = layer
	visual.show()
	hp = point

func _on_body_entered(body) -> void:
	if body is Player:
		body._hit()
	else:
		die()

func timeout():
	visual.hide()
	collision_layer = 0
