extends Resource
class_name Score

export (int) var retry := 0
export (int) var score := 0
export (int) var item := 0
export (int) var graze := 0
export (int) var bomb := 0
export (float) var death_duration
export (float) var game_speed

func save_score():
	var hud :HUD = Global.level.hud
	if hud.score > score:
		score = hud.score
		graze = hud.graze
		item = hud.item
		bomb = Global.player.bomb
		death_duration = Global.user_setting.death_duration
		game_speed = Global.user_setting.game_speed
