extends Node

var save

onready var viewport := get_viewport()
onready var tree := get_tree()
onready var tween :Tween = $Tween

func _ready() -> void:
	save = load('user://save.res')
	if not save:
		save = preload("res://autoload/save.res")
		save.new_save()

func instance_bullet(barrels:Array, Bullet:Resource, speed:int) -> void:
	for barrel in barrels:
		var properties = {
			"Transform" : Transform2D(barrel.global_rotation, barrel.global_position),
			"Velocity" : Vector2(speed, 0).rotated(barrel.global_rotation)
		}
		Bullets.spawn_bullet(Bullet, properties)
