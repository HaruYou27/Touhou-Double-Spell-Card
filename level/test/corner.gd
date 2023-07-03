extends Node2D

@export var final_position : Vector2
func start() -> void:
	create_tween().tween_property(self, 'position', final_position, 1.)

@onready var rest_position := position
@onready var recover := $RecoverTimer
func _on_enemy_died() -> void:
	position = rest_position
	recover.start()

@onready var physics := $Enemy
func _on_recover_timer_timeout():
	start()
	physics.reset()
