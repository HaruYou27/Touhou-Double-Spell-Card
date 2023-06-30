extends Node2D

@onready var animator := $AnimationPlayer
func start() -> void:
	animator.play("enter")

@onready var recover := $RecoverTimer
func _on_enemy_died() -> void:
	animator.play("RESET")
	recover.start()
	barrel.hide()

func _on_recover_timer_timeout():
	animator.play("enter")

@onready var barrel := $barrel
func _on_animation_player_animation_finished(_anim_name) -> void:
	barrel.show()
