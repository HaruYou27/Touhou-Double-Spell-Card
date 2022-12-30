extends Area2D
class_name Enemy

export (int) var hp := 1

onready var deathfx :Node2D = get_parent()

func _ready():
	Global.connect("bomb_impact", deathfx, 'queue_free')

func _hit():
	hp -= 1
	if hp <= 0:
		deathfx.global_position = global_position
		deathfx.start()
		queue_free()
