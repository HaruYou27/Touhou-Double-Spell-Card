extends Resource
class_name Score

@export_category('score')
@export var retry := 0
@export var score := 0
@export var item := 0
@export var graze := 0

@export_category('settings')
@export var death_time := .3
@export var game_speed := 1.0
@export var shoot_type := 0

func save_setting(type:int, wait_time:float) -> void:
	shoot_type = type
	death_time = wait_time
	game_speed = Engine.time_scale
	
	Global.save_resource(resource_path, self)

func save_score() -> void:
	var hud :HUD = Global.leveler.hud
	if hud.score > score:
		score = hud.score
		graze = hud.graze
		item = hud.item
	
	Global.save_resource(resource_path, self)
