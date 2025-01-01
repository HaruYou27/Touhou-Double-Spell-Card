extends Area2D
class_name Enemy

signal died

## Each bullet deal 1 damage.
@export var hp := 1
## Fair reward.
@onready var point = hp
var is_alive := true
func hit() -> void:
	if not hp and is_alive:
		die()
		return
		
	hp -= 1
	
@onready var explosion: CPUParticles2D = $explosion
@export var visual: Node2D

func die() -> void:
	hp = 0
	disable.call_deferred()
	#GlobalBullet.call_deferred("SpawnItems", point, global_position)
	explosion.emitting = true
	SoundEffect.tick1.play()
	is_alive = false
	died.emit()
	
	timeout()
	
func reset() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	monitoring = true
	monitorable = true
	is_alive = true
	visual.show()
	hp = point

func _ready() -> void:
	disable.call_deferred()

func _on_body_entered(body:Node2D) -> void:
	if body is not Player:
		die()
		return
		
	if not body.is_multiplayer_authority():
		return
	body.hit.call_deferred()

func timeout() -> void:
	disable.call_deferred()
	
func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	monitorable = false
	monitoring = false
	visual.hide()
