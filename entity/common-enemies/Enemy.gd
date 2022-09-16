extends Area2D
class_name Enemy

signal die

export (int) var hp
export (int) var point

onready var deathfx :Particles2D = $explosion

func _ready() -> void:
	connect("body_entered", self, '_on_body_entered')
	add_to_group('enemy')

func _hit() -> void:
	hp -= 1
	if hp:
		return
		
	ItemManager.SpawnItem(global_position, point)
	die()
	
func die() -> void:
	emit_signal('die')
	deathfx.emitting = true
	var tween := create_tween()
	tween.tween_property(deathfx, 'modulate', Color.transparent, 1.0)
	tween.connect("finished", self, 'queue_free')
	collision_layer = 0
	collision_mask = 0

func _on_body_entered(body):
	body._hit()
