extends Enemy

onready var sprite :Sprite = $sprite

func _ready() -> void:
	sprite.flip_h = bool(randi() % 2)
	rotation = randf() * TAU
	if randi() % 2:
		material = preload("res://entity/common-enemies/orb/backward.material")

func die() -> void:
	.die()
	sprite.hide()
