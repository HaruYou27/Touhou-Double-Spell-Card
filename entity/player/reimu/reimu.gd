extends Node

@export var seals : Array[FantasySeal]

func _on_player_bomb() -> void:
	for seal in seals:
		seal.position = Vector2.ZERO
		seal.toggle(true)
