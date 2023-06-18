extends StaticBody2D

signal finished

func _ready() -> void:
	Input.vibrate_handheld(2000)
	VisualEffect.shaking = 2.

@onready var animator := $AnimationPlayer
func _on_animation_player_animation_finished(_anim_name) -> void:
	finished.emit()
	hide()
	hitbox.set_deferred("disabled", true)

@onready var hitbox := $hitbox
func _on_player_kaboom():
	show()
	hitbox.set_deferred("disabled", false)
	animator.play("sweep")
