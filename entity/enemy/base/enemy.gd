extends Area2D
class_name Enemy

signal died

## Each bullet deal 1 damage.
@export var hp := 1
## Fair reward.
@onready var point = hp
var tick := false
@onready var blood: CPUParticles2D = $explosion/blood
@onready var blood2: CPUParticles2D = $explosion/blood2
func _hit() -> void:
	hp -= 1
	if tick:
		blood.emitting = true
	else:
		blood2.emitting = true
	if not hp:
		die()
		
@onready var explosion: CPUParticles2D = $explosion
@export var visual: Node2D

func die() -> void:
	disable.call_deferred()
	ItemManager.spawn_item(point, global_position)
	explosion.emitting = true
	SoundEffect.tick1.play()
	died.emit()
	
	timeout()
	
func reset() -> void:
	monitoring = true
	monitorable = true
	visual.show()
	hp = point

func _ready() -> void:
	disable.call_deferred()

func _on_body_entered(body) -> void:
	if body is Player:
		body.hit()
	else:
		die()

func timeout() -> void:
	disable.call_deferred()
	
func disable() -> void:
	monitorable = false
	monitoring = false
	visual.hide()
