extends Area2D
class_name Enemy

signal die

export (int) var hp
export (int) var point

func _ready() -> void:
	connect("body_entered", self, '_on_body_entered')

func _hit() -> void:
	hp -= 1
	if hp:
		return
	_die()
	
func _on_body_entered(body) -> void:
	body._hit()
	
func _die() -> void:
	ItemManager.SpawnItem(global_position, point)
	emit_signal('die')
	queue_free()
