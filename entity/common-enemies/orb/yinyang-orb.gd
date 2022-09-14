extends Enemy

onready var sprite :Sprite = $sprite

func _ready() -> void:
	sprite.flip_h = bool(randi() % 2)
	sprite.flip_v = bool(randi() % 2)
	if randi() % 2:
		material = preload("res://entity/common-enemies/orb/backward.material")
