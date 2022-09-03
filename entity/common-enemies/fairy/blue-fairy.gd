extends AnimatedSprite

export (int) var hp

onready var deathfx :Particles2D = $explosion

func _ready() -> void:
	flip_h = randi() % 1

func _hit() -> void:
	hp -= 1
	if not hp:
		visible = false
		var tween := create_tween()
		tween.tween_property(deathfx, 'modulate', 0.0, 1.0)
		tween.connect("finished", self, 'queue_free')

func _on_phantom_body_entered(body) -> void:
	Global.player._hit()
