extends Resource
class_name Score

export (int) var retry := 0
export (int) var score := 0
export (int) var item := 0
export (int) var graze := 0

export (float) var death_time := .3
export (float) var game_speed := 1.0
export (int) var shoot_type := 0

func save_setting(type, wait_time):
	shoot_type = type
	death_time = wait_time
	game_speed = Engine.time_scale
	
	Global.save_resource(resource_path, self)

func save_score():
	var hud :HUD = Global.leveler.hud
	if hud.score > score:
		score = hud.score
		graze = hud.graze
		item = hud.item
	
	Global.save_resource(resource_path, self)
