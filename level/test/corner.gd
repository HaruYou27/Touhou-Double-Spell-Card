extends Node2D

@onready var animator := $AnimationPlayer
func start() -> void:
	animator.play("enter")

@onready var recover := $RecoverTimer
func _on_enemy_died() -> void:
	animator.play("RESET")
	recover.start()

@onready var physics := $Enemy
func _on_recover_timer_timeout():
	animator.play("enter")
	physics.reset()
