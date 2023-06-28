extends StaticBody2D

signal finished

@onready var animator := $AnimationPlayer
func _on_animation_player_animation_finished(_anim_name) -> void:
	if is_multiplayer_authority():
		finished.emit()	

@onready var hitbox := $hitbox
func _on_player_kaboom(offset:float):
	animator.play("sweep")
	animator.seek(offset)
