extends Node2D
class_name Enemy

signal die

@export var hp := 1
@export var point := 0
@rpc("any_peer")
func hit() -> void:
	hp -= 1 
	if hp < 0:
		ItemManager.SpawnItem(point, global_position)
		VisualEffect.death_vfx(global_position)
		die.emit()
		queue_free()

func _hit() -> void:
	rpc('hit')
	hit()

func _on_hitbox_body_entered(body) -> void:
	if body is Player:
		body._hit()
	else:
		hp = 0
		_hit()
