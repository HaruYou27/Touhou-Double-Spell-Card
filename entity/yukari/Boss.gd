extends Area2D
class_name Boss

signal next_spell_card

@export var hp := 0
@onready var max_hp := hp

func _hit() -> void:
	hp -= 1
	if hp <= 0:
		ItemManager.SpawnItem(max_hp)
		next_spell_card.emit()

func _on_body_entered(body):
	if body is Player:
		body._hit()
