extends Resource
class_name Score

export (int) var hi_score := 0
export (int) var retry := 0
export (Array) var point := []
export (Array) var graze := []
export (Array) var bomb := []

func add_score(hud, path):
	point.append(hud.point)
	graze.append(hud.graze)
	bomb.append(Global.player.bombs)
	var score :int = point.back() * graze.back() * bomb.back()
	
	if score > hi_score:
		hi_score = score
		Global.save_resource(path, self)
