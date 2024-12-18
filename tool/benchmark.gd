extends Node

@export var item_count := 127

func spawn() -> void:
	GlobalBullet.SpawnItems(272, Vector2(270.0, 140.0))
