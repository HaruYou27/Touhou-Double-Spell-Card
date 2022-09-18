extends Particles2D

func start() -> void:
	emitting = true
	$sfx.play()
	var tween := create_tween()
	tween.tween_property(self, 'modulate', Color.transparent, lifetime)
	tween.connect("finished", self, 'queue_free')
