extends GPUParticles2D

func start():
	emitting = true
	$sfx.play()
	var tween := create_tween()
	tween.tween_property(self, 'modulate', Color.TRANSPARENT, lifetime)
	tween.connect("finished",Callable(self,'queue_free'))
