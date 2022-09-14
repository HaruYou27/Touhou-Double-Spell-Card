extends Area2D
class_name Enemy

export (int) var hp
export (int) var point

onready var deathfx :Particles2D = $explosion

func _ready() -> void:
	connect("body_entered", self, '_on_body_entered')

func _hit() -> void:
	hp -= 1
	if hp:
		return
		
	ItemManager.SpawnItem(global_position, point)
	die()
		
	deathfx.emitting = true
	var tween := create_tween()
	tween.tween_property(deathfx, 'modulate', Color.transparent, 1.0)
	tween.connect("finished", self, 'queue_free')
		
func die() -> void:
	pass

func _on_body_entered(body):
	Global.player._hit()
