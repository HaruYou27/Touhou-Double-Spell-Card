extends Node

func _ready() -> void:
	$"..".call_deferred("SpawnItem", 64, Vector2(270, 270))
