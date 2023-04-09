extends Resource
class_name Score

@export_category('score')
@export var retry := 0
@export var score := 0
@export var item := 0.
@export var graze := 0

@export_category('settings')
@export var death_time := .3
@export var game_speed := 1.
@export var shoot_type := preload("res://entity/Reimu/HomingShoot.tscn")

func save_setting(wait_time:float, type:PackedScene) -> void:
	death_time = wait_time
	shoot_type = type
	game_speed = Engine.time_scale
	
	ResourceSaver.save(self, resource_path, ResourceSaver.FLAG_COMPRESS)
