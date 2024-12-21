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
func hit() -> void:
	if not hp and is_alive:
		die()
		return
		
	hp -= 1
	if tick:
		blood.emitting = true
	else:
		blood2.emitting = true
	
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
	disable.call_deferred()

func _on_body_entered(body:Node2D) -> void:
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
