extends BulletBasic
class_name TimedAlpha

func create_bullet() -> void:
	bullet = Uni

func reset_bullet() -> void:
	RenderingServer.canvas_item_set_modulate(bullet.sprite, Color(Color.WHITE, abs(sin(Time.get_ticks_usec()))))
