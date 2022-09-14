extends Camera2D

const ani_length := .15

func _on_settings_pressed():
	create_tween().tween_property(self, 'position', Vector2(-1280, 0), ani_length)

func _on_back_pressed():
	create_tween().tween_property(self, 'position', Vector2.ZERO, ani_length)

func select_character():
	create_tween().tween_property(self, 'position', Vector2(1280, 0), ani_length)
