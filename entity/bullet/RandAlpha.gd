extends BulletBasic
class_name RandAlpha

func reset_bullet() -> void:
	RenderingServer.canvas_item_set_modulate(bullet.sprite, Color(Color.WHITE, abs(sin(bullet.transform.origin.length()))))
