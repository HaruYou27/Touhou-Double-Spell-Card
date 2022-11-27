extends Enemy

onready var sprite :Particles2D = $sprite

func die():
	sprite.hide()
	sprite.emitting = false
