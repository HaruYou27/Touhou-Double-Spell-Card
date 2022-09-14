extends Enemy

onready var sprite :AnimatedSprite = $sprite

func _ready() -> void:
	sprite.flip_h = bool(randi() % 2)

func die() -> void:
	sprite.hide()
