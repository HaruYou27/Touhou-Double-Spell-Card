extends Area2D
class_name Enemy

signal died

## Each bullet deal 1 damage.
@export var hp := 1
## Fair reward.
@onready var point = hp
func hit() -> void:
	if not hp:
		die()
		return
		
	hp -= 1
	
@onready var explosion: CPUParticles2D = $explosion
@export var visual: Node2D

func die() -> void:
	hp = 0
	disable.call_deferred()
	GlobalItem.call_deferred("spawn_circle", point, global_position)
	explosion.emitting = true
	SoundEffect.tick1.play()
	
	timeout()
	
func reset() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	monitoring = true
	monitorable = true
	visual.show()
	hp = point

@export var oneshot := false
func _ready() -> void:
	if not oneshot:
		disable.call_deferred()

func _on_body_entered(body:Node2D) -> void:
	if body is not Player:
		die()
		return
		
	if not body.is_multiplayer_authority():
		return
	body.hit.call_deferred()

func timeout() -> void:
	died.emit()
	disable.call_deferred()
	
func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	monitorable = false
	monitoring = false
	visual.hide()
