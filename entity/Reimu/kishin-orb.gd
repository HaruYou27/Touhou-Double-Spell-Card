extends StaticBody2D

func _ready() -> void:
	Input.vibrate_handheld(2000)
	VisualEffect.shaking = 2.

func _on_animation_player_animation_finished(_anim_name):
	Global.bomb_finished.emit()
	queue_free()
