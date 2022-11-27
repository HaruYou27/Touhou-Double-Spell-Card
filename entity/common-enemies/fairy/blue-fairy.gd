extends Enemy

onready var sprite :AnimatedSprite = $sprite

func _ready():
	sprite.flip_h = bool(randi() % 2)

func die():
	sprite.hide()
