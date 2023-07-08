extends BulletBasic
class_name SineAlpha

func reset_bullet() -> void:
	RenderingServer.canvas_item_set_modulate(bullet.sprite, Color(Color.WHITE, abs(sin(Time.get_ticks_msec()))))
