extends Area2D
class_name Enemy

signal died

## Each bullet deal 1 damage.
@export var hp := 1
## Fair reward.
@onready var point = hp
var tick := false
func hit() -> void:
	if not hp and is_alive:
		die()
		return
		
	hp -= 1
	
@onready var explosion: CPUParticles2D = $explosion
@export var visual: Node2D

var is_alive := true
func die() -> void:
	is_alive = false
	disable.call_deferred()
	GlobalBullet.call_deferred("SpawnItems", point, global_position)
	explosion.emitting = true
	SoundEffect.tick1.play()
	died.emit()
	
	timeout()
	
func reset() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	monitoring = true
	monitorable = true
	visual.show()
	hp = point
	is_alive = true

func _ready() -> void:
	disable()

func _on_body_entered(body:Player) -> void:
	if not body.is_multiplayer_authority():
		return
	body.hit()

func timeout() -> void:
	disable()
	
func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	monitorable = false
	monitoring = false
	visual.hide()
