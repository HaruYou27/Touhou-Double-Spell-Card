extends Area2D
class_name Enemy

signal died

## Each bullet deal 1 damage.
@export var hp := 1
## Fair reward.
@onready var point = hp
## Don't free the node, marked it instead.
var tick := false
@onready var blood: CPUParticles2D = $blood
@onready var blood2: CPUParticles2D = $blood2
func _hit() -> void:
	hp -= 1
	if tick:
		blood.emitting = true
	else:
		blood2.emitting = true
	if not hp:
		die()
		
@onready var explosion: CPUParticles2D = $explosion
@onready var visual := $visual
var layer := 0

func die() -> void:
	collision_layer = 0
	ItemManager.spawn_item(point, global_position)
	explosion.emitting = true
	SoundEffect.tick1.play()
	died.emit()
	timeout()
	
func _ready() -> void:
	layer = collision_layer
	collision_layer = 0

func reset() -> void:
	collision_layer = layer
	visual.show()
	hp = point

func _on_body_entered(body) -> void:
	if body is Player:
		body.hit()
	else:
		die()

func timeout():
	visual.hide()
	collision_layer = 0
