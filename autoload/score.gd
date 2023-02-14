extends Resource
class_name Score

export (int) var retry := 0
export (int) var score := 0
export (int) var item := 0
export (int) var graze := 0
export (int) var bomb := 0
export (float) var death_duration := .3
export (float) var game_speed := 1.0

func save_score():
	var hud :HUD = Global.leveler.hud
	if hud.score > score:
		score = hud.score
		graze = hud.graze
		item = hud.item
		bomb = Global.player.bomb
	
	Global.save_resource(resource_path, self)
